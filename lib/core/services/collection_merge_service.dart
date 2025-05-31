// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu Collection-Merging, Datenmodellierung und Teststrategie.
// Lessons Learned: Die Funktion buildPodcastHostCollectionFromSources vereint Daten aus iTunes, RSS und lokaler JSON zu einer robusten Collection. Besonderheiten: Priorisierung von Datenquellen, flexible FeatureFlags, testbare Merge-Logik. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Funktion ist so gestaltet, dass sie leicht um weitere Datenquellen und Feature-Flags erweitert werden kann. Siehe ADR-003 für Teststrategie und Lessons Learned.

import '../../domain/models/podcast_host_collection_model.dart'
    as host_collection;
import '../../domain/models/podcast_model.dart';
import '../../domain/models/host_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../domain/models/collection_meta_model.dart';
import '../../domain/models/data_origin_model.dart';
import '../../domain/enums/data_source_type.dart';
import '../../domain/models/merge_models.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/feature_flags_model.dart';
import '../../domain/models/localization_config_model.dart';
import '../../domain/models/host_content_model.dart';

/// Führt die Daten aus iTunes, RSS und lokaler JSON zu einer PodcastHostCollection zusammen.
Future<host_collection.PodcastHostCollection>
    buildPodcastHostCollectionFromSources({
  required ItunesData itunes,
  required RssData rss,
  required LocalJsonData local,
  required Podcast podcast,
  required List<PodcastEpisode> episodes,
  Host? fallbackHost,
}) async {
  // Host-Objekt bauen (Branding, Kontakt, etc. aus JSON bevorzugt)
  final host = fallbackHost ??
      Host(
        collectionId:
            itunes.collectionId ?? local.collectionId ?? podcast.collectionId,
        hostName:
            itunes.artistName ?? rss.author ?? local.author ?? 'Unbekannt',
        description: itunes.shortDescription ??
            rss.description ??
            local.description ??
            '',
        contact: ContactInfo(email: rss.ownerEmail ?? local.contactEmail ?? ''),
        branding: Branding(
          logoUrl: rss.imageUrl ?? itunes.artworkUrl600 ?? local.imageUrl ?? '',
        ),
        features: FeatureFlags(
          showPortfolioTab:
              local.featureFlags?.contains('showPortfolioTab') ?? false,
          enableContactForm:
              local.featureFlags?.contains('enableContactForm') ?? false,
          showPodcastGenre:
              local.featureFlags?.contains('showPodcastGenre') ?? false,
          customStartTab: local.featureFlags
              ?.firstWhere(
                (f) => f.startsWith('customStartTab:'),
                orElse: () => 'home',
              )
              .replaceFirst('customStartTab:', ''),
        ),
        localization: LocalizationConfig.empty(),
        content: HostContent.empty(),
        primaryGenreName: podcast.primaryGenreName,
        authTokenRequired: local.authTokenRequired ?? false,
        debugOnly: false,
        lastUpdated: DateTime.now(),
      );

  // Meta-Informationen
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
    hostOrigin: DataOrigin(
      source: DataSourceType.json, // oder dynamisch bestimmen
      updatedAt: DateTime.now().toIso8601String(),
      isFallback: false,
    ),
  );

  return host_collection.PodcastHostCollection(
    collectionId:
        itunes.collectionId ?? local.collectionId ?? podcast.collectionId,
    podcast: podcast,
    episodes: episodes,
    host: host,
    downloadedAt: DateTime.now(),
    meta: meta,
  );
}
