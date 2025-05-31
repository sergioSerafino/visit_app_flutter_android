import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/common/api_response.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import 'repository_provider.dart';

/// Lädt eine gesamte PodcastCollection anhand der Collection-ID
final podcastCollectionProvider =
    FutureProvider.family<ApiResponse<PodcastCollection>, int>(
  (ref, collectionId) async {
    final repository = ref.watch(podcastRepositoryProvider);
    return await repository.fetchPodcastCollectionById(collectionId);
  },
);

/// Lädt alle Episoden, wenn der EpisodeLoadController es erlaubt
final podcastEpisodeProvider =
    FutureProvider.family<List<PodcastEpisode>, int>((ref, collectionId) async {
  final repository = ref.watch(podcastRepositoryProvider);
  final response = await repository.fetchPodcastEpisodes(collectionId);

  if (!response.isSuccess || response.data == null) {
    throw Exception(
      "Fehler beim Laden der Episoden: ${response.errorMessage ?? "Unbekannter Fehler"}",
    );
  }

  return response.data!;
});
