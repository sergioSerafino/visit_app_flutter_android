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
    return await repository.fetchPodcastCollectionById(collectionId,
        limit: limit);
  },
);

/// Lädt alle Episoden, wenn der EpisodeLoadController es erlaubt

/// Lädt alle Episoden, gibt bei Fehler/Offline/leer immer konsistente Placeholder zurück.
/// State-Management- und Fallback-Pattern gemäß Architektur- und PRD-Doku:
/// API > Cache > JSON > Placeholder (siehe .instructions/howto_placeholder_fallback.md, PRD, README)
final podcastEpisodeProvider =
    FutureProvider.family<List<PodcastEpisode>, int>((ref, collectionId) async {
  final repository = ref.watch(podcastRepositoryProvider);
  final limit = ref.watch(itunesResultCountProvider);
  final response =
      await repository.fetchPodcastEpisodes(collectionId, limit: limit);

  // Erfolgreich: Echte Episoden zurückgeben
  if (response.isSuccess &&
      response.data != null &&
      response.data!.isNotEmpty) {
    return response.data!;
  }

  // Fehler/Offline/leer: Immer konsistente Placeholder-Episoden zurückgeben
  // Siehe PlaceholderContent.placeholderEpisodes
  return PlaceholderContent.placeholderEpisodes;
});

/// Doku: Die Provider geben das Ergebnis-Limit immer aus dem zentralen itunesResultCountProvider an das Repository weiter.
/// Siehe README.md und itunes_result_count_provider.dart für Details.
