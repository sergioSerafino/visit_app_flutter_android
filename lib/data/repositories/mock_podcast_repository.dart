// Repository für einen Podcast von einer Mock-Datenquelle
import '../../domain/common/api_response.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../data/repositories/podcast_repository.dart';

class MockPodcastRepository implements PodcastRepository {
  final Duration fakeDelay;

  MockPodcastRepository({this.fakeDelay = const Duration(seconds: 1)});

  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollectionById(
    int id, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    await Future.delayed(fakeDelay);

    // Mock-Daten mit vollständigem API-Format
    final mockJsonResponse = {
      "resultCount": 3,
      "results": [
        {
          "kind": "podcast",
          "wrapperType": "track",
          "collectionId": id,
          "collectionName": "Mock Podcast",
          "artistName": "artistName",
          "primaryGenreName": "Test-Genre 1",
          "artworkUrl600": "",
          "feedUrl": "",
        },
        {
          "wrapperType": "podcastEpisode",
          "collectionId": id,
          "trackId": 101,
          "trackName": "Mock Folge 1",
          "artworkUrl600": "",
          "description": "Mock-Beschreibung 1",
          "episodeUrl": "https://example.com/audio1.mp3",
          "trackTimeMillis": 1150000,
          "episodeFileExtension": "mp3",
          "releaseDate": "2025-01-01T10:00:00Z",
        },
        {
          "wrapperType": "podcastEpisode",
          "collectionId": id,
          "trackId": 102,
          "trackName": "Mock Folge 2",
          "artworkUrl600": "",
          "description": "Mock-Beschreibung 2",
          "episodeUrl": "https://example.com/audio2.mp3",
          "trackTimeMillis": 1150000,
          "episodeFileExtension": "mp3",
          "releaseDate": "2025-02-01T10:00:00Z",
        },
      ],
    };

    // Limitiere die Ergebnisse, falls limit gesetzt ist
    final limitedResults = limit != null
        ? (mockJsonResponse['results'] as List).take(limit).toList()
        : mockJsonResponse['results'];
    mockJsonResponse['results'] = limitedResults as List<Object?>;

    try {
      final parsed = PodcastCollection.fromApiJson(mockJsonResponse);
      return ApiResponse.success(parsed);
    } catch (e) {
      return ApiResponse.error("Fehler beim Mock-Parsen: $e");
    }
  }

  @override
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    await Future.delayed(fakeDelay * 2);

    // Beispielhafte Episoden mit vollständigen Details
    final mockEpisodes = [
      PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: 001,
        trackName: "Mock Episode 1",
        artworkUrl600: "",
        episodeUrl: "https://example.com/ep1.mp3",
        trackTimeMillis: 1150000,
        episodeFileExtension: "mp3",
        releaseDate: DateTime.parse("2021-01-01T11:11:11Z"),
        description: "Datensatz gehört zu Mock Episode 1.",
      ),
      PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: 456,
        trackName: "Mock Episode 2",
        artworkUrl600: "",
        episodeUrl: "https://example.com/ep2.mp3",
        trackTimeMillis: 1150000,
        episodeFileExtension: "mp3",
        releaseDate: DateTime.parse("2022-02-02T20:20:20Z"),
        description: "Dies ist die Beschreibung für Episode 2.",
      ),
      PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: 789,
        trackName: "Mock Episode 3",
        artworkUrl600: "",
        episodeUrl: "https://example.com/ep3.mp3",
        trackTimeMillis: 1150000,
        episodeFileExtension: "mp3",
        releaseDate: DateTime.parse("2033-03-03T13:33:33Z"),
        description: "Dies ist die Beschreibung für Episode 3.",
      ),
      PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: 123,
        trackName: "Mock Episode 4",
        artworkUrl600: "",
        episodeUrl: "https://example.com/ep4.mp3",
        trackTimeMillis: 1150000,
        episodeFileExtension: "mp3",
        releaseDate: DateTime.parse("2024-03-25T10:53:38Z"),
        description: "Dies ist die Beschreibung für Episode 4.",
      ),
    ];

    // Limitiere die Episoden, falls limit gesetzt ist
    final limitedEpisodes =
        limit != null ? mockEpisodes.take(limit).toList() : mockEpisodes;
    return ApiResponse.success(limitedEpisodes);
  }

  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection(
      {int? limit, String? country, String? entity, String? media}) async {
    await Future.delayed(const Duration(seconds: 1));

    // API-ähnliches JSON: Map mit `resultCount` und `results`
    final mockJsonResponse = {
      "resultCount": 5,
      "results": [
        // ...optional weitere Mock-Daten...
      ],
    };

    // Limitiere die Ergebnisse, falls limit gesetzt ist
    final limitedResults = limit != null
        ? (mockJsonResponse['results'] as List).take(limit).toList()
        : mockJsonResponse['results'];
    mockJsonResponse['results'] = limitedResults as List<Object?>;

    final parsedCollection = PodcastCollection.fromApiJson(mockJsonResponse);
    return ApiResponse.success(parsedCollection);
  }
}

/// Doku: Das MockRepository unterstützt jetzt alle API-Parameter und verhält sich wie die echten Implementierungen. Siehe README.md und podcast_repository.dart für Details.
