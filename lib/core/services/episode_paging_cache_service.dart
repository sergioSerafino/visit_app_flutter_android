// lib/core/services/episode_paging_cache_service.dart
// Hive-basierter Paging-Cache für Episodenlisten
// Schema: Box 'episodePagesBox', Key: 'collectionId_pageIndex', Value: { data: [...], timestamp: ... }

import '../../domain/models/podcast_episode_model.dart';
import 'generic_paging_cache_service.dart';

class EpisodePagingCacheService {
  static const String _boxName = 'episodePagesBox';
  static const Duration defaultTtl = Duration(hours: 1);
  final _generic = GenericPagingCacheService<PodcastEpisode>(
    boxName: _boxName,
    fromJson: PodcastEpisode.fromJson,
    defaultTtl: defaultTtl,
  );

  Future<void> savePage(
    int collectionId,
    int pageIndex,
    List<PodcastEpisode> episodes,
  ) async {
    await _generic.savePage(
      collectionId.toString(),
      pageIndex,
      episodes,
      (e) => e.toJson(),
    );
  }

  Future<List<PodcastEpisode>?> loadPage(
    int collectionId,
    int pageIndex,
  ) async {
    return await _generic.loadPage(collectionId.toString(), pageIndex);
  }

  Future<bool> isPageFresh(
    int collectionId,
    int pageIndex, {
    Duration? ttl,
  }) async {
    return await _generic.isPageFresh(
      collectionId.toString(),
      pageIndex,
      ttl: ttl,
    );
  }

  Future<void> invalidatePage(int collectionId, int pageIndex) async {
    await _generic.invalidatePage(collectionId.toString(), pageIndex);
  }
}
