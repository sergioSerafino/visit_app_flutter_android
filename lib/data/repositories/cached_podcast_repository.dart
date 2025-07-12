// ...original code from storage_hold/lib/data/repositories/cached_podcast_repository.dart...
// Repository für Podcast-Daten aus dem lokalen Hive-Cache
import '../../domain/common/api_response.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../data/repositories/podcast_repository.dart';
import '../api/local_cache_client.dart';

class CachedPodcastRepository implements PodcastRepository {
  final LocalCacheClient _cacheClient;

  CachedPodcastRepository({required LocalCacheClient cacheClient})
      : _cacheClient = cacheClient;

  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection({
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    final collection = await _cacheClient.getPodcastCollection();
    if (collection != null) {
      return ApiResponse.success(collection);
    }
    return ApiResponse.error('Keine PodcastCollection im Cache gefunden');
  }

  @override
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    final episodes = await _cacheClient.getPodcastEpisodes(collectionId);
    if (episodes != null && episodes.isNotEmpty) {
      return ApiResponse.success(episodes);
    }
    return ApiResponse.error('Keine Episoden im Cache gefunden');
  }

  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollectionById(
    int id, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    final collection = await _cacheClient.getPodcastCollection();
    if (collection != null &&
        collection.podcasts.any((p) => p.collectionId == id)) {
      return ApiResponse.success(collection);
    }
    return ApiResponse.error(
        'PodcastCollection mit ID $id nicht im Cache gefunden');
  }
}
