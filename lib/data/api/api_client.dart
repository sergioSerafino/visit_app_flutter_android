// ...original code from storage_hold/lib/data/api/api_client.dart...
// lib/data/api/api_client.dart
// Instanz von Dio-basiertem API-Client: apiClientProvider

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/logging/logger_config.dart';
import '../../../core/utils/podcast_collection_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/common/api_response.dart';
import '../../../data/api/api_endpoints.dart';
import '../../../domain/models/podcast_collection_model.dart';
import '../../../domain/models/podcast_episode_model.dart';
import '../../core/utils/retry_on_connection_change_interceptor.dart';
import '../../core/messaging/feedback_notifier.dart';
import '../../presentation/feedback/snackbar_feedback_notifier.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio();
  final feedbackNotifier = ref.read(feedbackNotifierProvider);
  dio.interceptors.add(
    RetryOnConnectionChangeInterceptor(
      dio: dio,
      connectivity: Connectivity(),
      feedbackNotifier: feedbackNotifier,
    ),
  );
  return ApiClient.withDio(dio);
});

class ApiClient {
  final Dio _dio;
  ApiClient.withDio(this._dio);

  /// 🔎 Holt alle Podcasts + Episoden aus der iTunes Collection
  Future<ApiResponse<PodcastCollection>> getPodcastCollection() async {
    try {
      final url = ApiEndpoints.podcastCollection;
      final response = await _dio.get(url);

      logDebug("📡 GET: $url", color: LogColor.cyan, tag: LogTag.api);
      logDebug(
        "🤖 Type check: ${response.data.runtimeType}",
        color: LogColor.green,
        tag: LogTag.data,
      );
      logDebug(
        "📦 Inhalt: ${response.data}",
        color: LogColor.green,
        tag: LogTag.data,
      );

      final parsedJson =
          response.data is String ? jsonDecode(response.data) : response.data;

      // Verwende den Parser
      final collection = PodcastCollectionParser.parsePodcastData(parsedJson);

      return ApiResponse.success(collection);
    } catch (e) {
      logDebug(
        "Fehler bei getPodcastCollection: $e",
        color: LogColor.red,
        tag: LogTag.error,
      );
      return ApiResponse.error("Fehler beim Parsen der Podcast Collection: $e");
    }
  }

  /// 🔎 Holt Podcasts + Episoden via Collection ID
  Future<ApiResponse<PodcastCollection>> getPodcastCollectionById(
    int collectionId, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    try {
      final url = ApiEndpoints.podcastLookup(
        collectionId: collectionId,
        limit: limit ?? 3,
        country: country,
        entity: entity ?? 'podcastEpisode',
        media: media,
      );
      final response = await _dio.get(url);

      logDebug("📡 GET: $url", color: LogColor.cyan, tag: LogTag.api);
      logDebug(
        "🤖 Type check: ${response.data.runtimeType}",
        color: LogColor.green,
        tag: LogTag.data,
      );
      logDebug(
        "📦 Inhalt: ${response.data}",
        color: LogColor.green,
        tag: LogTag.data,
      );

      final parsedJson =
          response.data is String ? jsonDecode(response.data) : response.data;

      final collection = PodcastCollectionParser.parsePodcastData(parsedJson);

      return ApiResponse.success(collection);
    } catch (e) {
      logDebug(
        "Fehler bei getPodcastCollectionById: $e",
        color: LogColor.red,
        tag: LogTag.error,
      );
      return ApiResponse.error("Fehler beim Parsen der Collection by ID: $e");
    }
  }

  /// Holt Episoden für eine bestimmte Collection ID via iTunes-API
  Future<ApiResponse<List<PodcastEpisode>>> getPodcastEpisodes(
    int collectionId, {
    int? limit,
    String? country,
    String? entity,
    String? media,
  }) async {
    try {
      final url = ApiEndpoints.podcastEpisodes(
        collectionId,
        limit: limit ?? 3,
      );
      final response = await _dio.get(url);

      final parsedJson =
          response.data is String ? jsonDecode(response.data) : response.data;

      // iTunes gibt alle Daten in "results" zurück, inklusive Meta-Objekten
      final episodes = (parsedJson['results'] as List)
          .where((e) => e['wrapperType'] == 'podcastEpisode')
          .map((json) => PodcastEpisode.fromApiJson(json))
          .toList();

      logDebug("📡 GET: $url", color: LogColor.cyan, tag: LogTag.api);
      logDebug(
        "📦 Episodenanzahl: ${episodes.length}",
        color: LogColor.green,
        tag: LogTag.data,
      );

      return ApiResponse.success(episodes);
    } catch (e) {
      logDebug(
        "Fehler bei getPodcastEpisodes: $e",
        color: LogColor.red,
        tag: LogTag.error,
      );
      return ApiResponse.error("Fehler beim Parsen der Episoden: $e");
    }
  }

  /// 🧪 Low-Level GET (z.B. für Debug oder Zusatzrequests)
  Future<dynamic> get(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final jsonData = jsonDecode(body);
        return jsonData;
      } else {
        throw Exception('Fehler beim API-Aufruf: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API-Aufruf fehlgeschlagen: $e');
    }
  }

  /*
// Wenn du später Auth einbaust, kannst du in ApiClient 
// einfach Interceptors hinzufügen:

_dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] = 'Bearer yourToken';
    return handler.next(options);
  },
));
*/
}

/*

Das Problem kurz zusammengefasst:
Die API gibt bereits fertige PodcastCollection zurück → perfekt!
Die MockPodcastRepository wurde auf Rohdaten umgestellt.
Der Fehler tritt auf, wenn der podcastCollectionProvider fetchPodcastCollectionById() vom Repository verwendet, weil dort je nach Modus unterschiedliche Rückgabetypen geliefert werden.
Deshalb crasht's beim Wechsel – z.B. API liefert ein fertiges Modell, aber irgendwo erwartet noch Map<String, dynamic>, oder andersrum.
Hier muss jetzt ebenfalls eine PodcastCollection zurückgegeben werden, genauso wie es ApiPodcastRepository macht – nicht Map<String, dynamic>!
MockPodcastRepository.fetchPodcastCollectionById():
Ich zeige dir gerne alle Files die du dazu brauchst hauptsache ich muss nicht noch ein x-tes mal alles wieder ändern: API- ist die source of Truth. Die Modells funktionieren endlich perfekt weil sie das gekapselte itunes-Json auseinandernehmen und neu zusammensetzen. das ist so weit alles richtig. jetzt haben wir Mock auch auf roh daten umgestellt wie du vorgeschlagen hast. Dann lass uns als nächstes mal ansehen was notwenig ist, dass nicht diesen ungewünschten aussetzer passieren und das ganze solid-tauglich im Projekt funktioniert. Sag mir bitte wenn du mehr brauchst
 */
