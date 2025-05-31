// ...original code from storage_hold/lib/data/repositories/podcast_repository.dart...
// lib/data/repositories/podcast_repository.dart
// Repository (Datenquelle) -Interface für die Abstraktion von Podcast
import '../../../domain/common/api_response.dart';
import '../../../domain/models/podcast_collection_model.dart';
import '../../../domain/models/podcast_episode_model.dart';

// Factory-Pattern für PodcastRepository damit der Wechsel
// sauber läuft
abstract class PodcastRepository {
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection();
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId,
  );
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollectionById(int id);
  // Future<ApiResponse<HostInfo>> fetchHostInfoForCollection(int collectionId);
}
