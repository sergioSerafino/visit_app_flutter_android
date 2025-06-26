import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/common/api_response.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import 'repository_provider.dart';
import 'itunes_result_count_provider.dart';
import '../../core/placeholders/placeholder_content.dart';

/// Lädt eine gesamte PodcastCollection anhand der Collection-ID
final podcastCollectionProvider =
    FutureProvider.family<ApiResponse<PodcastCollection>, int>(
  (ref, collectionId) async {
    final repository = ref.watch(podcastRepositoryProvider);
    final limit = ref.watch(itunesResultCountProvider);
    final response =
        await repository.fetchPodcastCollectionById(collectionId, limit: limit);
    // --- Fallback auf Placeholder, wenn API und Cache fehlschlagen ---
    if (!response.isSuccess || response.data == null) {
      // Logik: PlaceholderContent wird als Notlösung zurückgegeben
      return ApiResponse.success(PlaceholderContent.podcastCollection);
    }
    return response;
  },
);

/// Lädt alle Episoden, wenn der EpisodeLoadController es erlaubt
final podcastEpisodeProvider =
    FutureProvider.family<List<PodcastEpisode>, int>((ref, collectionId) async {
  final repository = ref.watch(podcastRepositoryProvider);
  final limit = ref.watch(itunesResultCountProvider);
  final response =
      await repository.fetchPodcastEpisodes(collectionId, limit: limit);

  // --- Fallback auf Placeholder-Episoden, wenn API und Cache fehlschlagen ---
  if (!response.isSuccess || response.data == null) {
    // Logik: PlaceholderContent wird als Notlösung zurückgegeben
    return PlaceholderContent.podcastCollection.podcasts.first.episodes;
  }

  return response.data!;
});

/// Doku: Die Provider geben das Ergebnis-Limit immer aus dem zentralen itunesResultCountProvider an das Repository weiter.
/// Siehe README.md und itunes_result_count_provider.dart für Details.
