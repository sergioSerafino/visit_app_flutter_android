// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu Collection-Merging, Caching und Datenquellen.
// Lessons Learned: MergeService kapselt die Zusammenführung von iTunes-, RSS- und lokalen JSON-Daten zu einer konsistenten PodcastHostCollection. Besonderheiten: Testbare, asynchrone Merge-Logik, TTL-basierter Cache, Fehlerbehandlung bei Datenquellen-Ausfall. Siehe zugehörige Provider und Widget-Tests.
//
// Weitere Hinweise: Die Architektur erlaubt flexible Erweiterung um neue Datenquellen und unterstützt Clean-Architektur-Prinzipien (Trennung von Daten, Domain, Anwendung). Siehe ADR-003 für Teststrategie und Lessons Learned.

import '../../domain/models/podcast_host_collection_model.dart'
    as host_collection;
import '../../domain/models/collection_meta_model.dart';
import '../../domain/models/data_origin_model.dart';
import '../../domain/models/host_model.dart';
import '../../data/repositories/podcast_repository.dart';
import '../placeholders/placeholder_loader_service.dart';
import '../utils/rss_service.dart'; // RSS-Service hinzugefügt
import '../../domain/enums/data_source_type.dart'; // Aktualisierte Enum verwenden
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/feature_flags_model.dart';
import '../../domain/models/localization_config_model.dart';
import '../../domain/models/host_content_model.dart';
import '../../domain/models/merge_models.dart';
import 'merged_collection_cache_service.dart';

class MergeService {
  final PodcastRepository podcastRepo;
  final PlaceholderLoaderService placeholderLoader;
  final RssService rssService;
  final MergedCollectionCacheService cacheService;

  MergeService({
    required this.podcastRepo,
    required this.placeholderLoader,
    required this.rssService,
    required this.cacheService,
  });

  Future<host_collection.PodcastHostCollection> merge(int collectionId) async {
    // 0. Prüfe Cache (TTL)
    if (await cacheService.isFresh(collectionId)) {
      final cached = await cacheService.load(collectionId);
      if (cached != null) return cached;
    }

    // 1. iTunes Basis laden
    final collection = await podcastRepo.fetchPodcastCollectionById(
      collectionId,
    );
    final podcast = collection.maybeWhen(
      success: (data) => data.podcasts.first,
      orElse: () => null,
    );
    if (podcast == null) {
      throw Exception('Podcast-Daten konnten nicht geladen werden.');
    }
    final episodes = podcast.episodes;

    // 2. Optional RSS, wenn feedUrl verfügbar
    final rssUrl = podcast.feedUrl;
    RssData? rssData;
    DataOrigin hostOrigin;
    if (rssUrl != null && rssUrl.isNotEmpty) {
      try {
        rssData = await rssService.fetchRssData(rssUrl);
        hostOrigin = DataOrigin(
          source: DataSourceType.rss,
          updatedAt: DateTime.now().toIso8601String(),
          isFallback: false,
        );
      } catch (_) {
        rssData = null;
        hostOrigin = DataOrigin(
          source: DataSourceType.json,
          updatedAt: DateTime.now().toIso8601String(),
          isFallback: true,
        );
      }
    } else {
      rssData = null;
      hostOrigin = DataOrigin(
        source: DataSourceType.json,
        updatedAt: DateTime.now().toIso8601String(),
        isFallback: true,
      );
    }

    // 3. Lokale JSON-Daten (about.json/host_model.json) - Instanzmethode für Testbarkeit
    final localData = await placeholderLoader.loadLocalJsonData(collectionId);

    // 4. Merge-Logik: Host bauen (nur Felder, die LocalJsonData wirklich hat)
    final mergedHost = Host(
      collectionId: podcast.collectionId,
      hostName: podcast.artistName,
      description: rssData?.description ?? localData.description ?? '',
      contact: ContactInfo(
        email: rssData?.ownerEmail ?? localData.contactEmail ?? '',
      ),
      branding: Branding(
        logoUrl: rssData?.imageUrl ??
            (podcast.artworkUrl600.isNotEmpty
                ? podcast.artworkUrl600
                : localData.imageUrl),
      ),
      features: FeatureFlags(
        showPortfolioTab:
            localData.featureFlags?.contains('showPortfolioTab') ?? false,
      ),
      localization: LocalizationConfig.empty(), // ggf. erweitern
      content: HostContent.empty(), // ggf. erweitern
      primaryGenreName: podcast.primaryGenreName,
      authTokenRequired: localData.authTokenRequired ?? false,
      lastUpdated: DateTime.now(),
    );

    // 5. Meta-Informationen
    final meta = CollectionMeta(
      podcastOrigin: DataOrigin(
        source: DataSourceType.itunes,
        updatedAt: DateTime.now().toIso8601String(),
        isFallback: false,
      ),
      episodeOrigin: DataOrigin(
        source: DataSourceType.itunes,
        updatedAt: DateTime.now().toIso8601String(),
        isFallback: false,
      ),
      hostOrigin: hostOrigin,
    );

    // Am Ende: Speichere gemergte Collection im Cache
    final merged = host_collection.PodcastHostCollection(
      collectionId: podcast.collectionId,
      podcast: podcast,
      episodes: episodes,
      host: mergedHost,
      downloadedAt: DateTime.now(),
      meta: meta,
    );
    await cacheService.save(merged);
    return merged;
  }
}
