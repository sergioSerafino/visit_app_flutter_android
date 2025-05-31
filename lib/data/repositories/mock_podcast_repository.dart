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
    int id,
  ) async {
    await Future.delayed(
      fakeDelay,
    ); // Simulierte Netzwerkwartezeit

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

    try {
      final parsed = PodcastCollection.fromApiJson(mockJsonResponse);
      return ApiResponse.success(parsed);
    } catch (e) {
      return ApiResponse.error("Fehler beim Mock-Parsen: $e");
    }
  }

  @override
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId,
  ) async {
    await Future.delayed(
      fakeDelay * 2,
    ); // Simuliere eine kurze Wartezeit

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

    return ApiResponse.success(mockEpisodes);
  }

  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simuliere eine kurze Wartezeit

    // API-ähnliches JSON: Map mit `resultCount` und `results`
    final mockJsonResponse = {
      "resultCount": 5,
      "results": [
        // ...optional weitere Mock-Daten...
      ],
    };

    final parsedCollection = PodcastCollection.fromApiJson(mockJsonResponse);
    return ApiResponse.success(parsedCollection);
  }
}
