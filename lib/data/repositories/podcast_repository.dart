// ...original code from storage_hold/lib/data/repositories/podcast_repository.dart...
// lib/data/repositories/podcast_repository.dart
// Repository (Datenquelle) -Interface für die Abstraktion von Podcast
import '../../../domain/common/api_response.dart';
import '../../../domain/models/podcast_collection_model.dart';
import '../../../domain/models/podcast_episode_model.dart';

// Factory-Pattern für PodcastRepository damit der Wechsel
// sauber läuft
abstract class PodcastRepository {
  /// Holt eine PodcastCollection (z.B. für die Startseite)
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection(
      {int? limit, String? country, String? entity, String? media});

  /// Holt Episoden einer Collection, limit steuerbar (zukunftssicher für alle Plattformen)
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  });

  /// Holt eine bestimmte Collection per ID, limit steuerbar
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollectionById(
    int id, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  });
  // Future<ApiResponse<HostInfo>> fetchHostInfoForCollection(int collectionId);
}

/// Doku: Das Interface ist so gestaltet, dass alle API-Parameter (limit, country, entity, media) flexibel und plattformunabhängig übergeben werden können.
/// Siehe README.md Abschnitt "Repository-Pattern & API-Parameter" für Details und Querverweise.
