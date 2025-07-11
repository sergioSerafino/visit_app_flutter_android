// ...original code from storage_hold/lib/data/repositories/api_podcast_repository.dart...
// lib/data/repositories/api_podcast_repository.dart
// Repository (Datenquelle) für einen Podcast von einer API

import '../../domain/common/api_response.dart';
import '../../core/extensions/podcast_collection_debug_extension.dart';
import '../../core/logging/logger_config.dart';
import '../../data/api/api_client.dart';
import '../../data/api/local_cache_client.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../data/repositories/podcast_repository.dart';

class ApiPodcastRepository implements PodcastRepository {
  final ApiClient _apiClient;
  final LocalCacheClient _cacheClient;

  ApiPodcastRepository({
    required ApiClient apiClient,
    required LocalCacheClient cacheClient,
  })  : _apiClient = apiClient,
        _cacheClient = cacheClient;

  /*
    Nur Dio verwenden, da dein Projekt darauf ausgelegt ist.
    Kein http.get(...) mehr einbauen – das passt nicht zum Rest.
*/

  // 🔄 Fetch + Cache: Eine bestimmte PodcastCollection anhand ihrer ID
  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollectionById(
    int collectionId,
  ) async {
    try {
      //    🔄 Episoden im lokalen Cache abfragen
      //    ⏱ Timestamp-Check (optional, Cache verwenden nur wenn frisch)
      final cachedCollection = await _cacheClient.getPodcastCollection();
      final cachedEpisodes = await _cacheClient.getPodcastEpisodes(
        collectionId,
      );

      final isCacheFresh = cachedCollection != null &&
          cachedCollection.downloadedAt != null &&
          DateTime.now().difference(cachedCollection.downloadedAt!).inHours <
              12;

      // ✅ Wenn Cache fresh ist UND Episoden vorhanden sind
      if (isCacheFresh && cachedEpisodes != null && cachedEpisodes.isNotEmpty) {
        return ApiResponse.success(cachedCollection);
      }

      // 🌐 API-Aufruf, kein (oder kein gültiger) Cache vorhanden
      final response = await _apiClient.getPodcastCollectionById(collectionId);

      if (response.data == null) {
        return const ApiResponse.error("Keine Daten von der API erhalten.");
      }

      // 🧠 Entweder liefert die API schon ein fertiges Objekt (Mock),
      // oder es kommt rohes JSON (dann müssen wir es mappen)
      late final PodcastCollection collection;

      if (response.data is PodcastCollection) {
        // ✅ Direkt nutzbar (z. B. aus Mock)
        collection = response.data as PodcastCollection;
      } else if (response.data is Map<String, dynamic>) {
        // ✅ JSON kam zurück → Mapping notwendig
        final rawJson = response.data as Map<String, dynamic>;
        collection = PodcastCollection.fromApiJson(rawJson);
      } else {
        // ❌ Fehlerhafter oder unerwarteter Typ
        return ApiResponse.error(
          "Unerwarteter API-Datentyp: ${response.data.runtimeType}",
        );
      }

      // Wenn leer zurückkam, trotzdem klarer Fehler
      if (collection.podcasts.isEmpty) {
        return const ApiResponse.error("API-Response enthält keine Podcasts.");
      }

      collection.debugPrettyPrint();
      // DEBUG: Seh dir response.data, runtimeType und ein Mapping -> collection an
      logDebug(
        "📡 Raw response: ${response.data}",
        tag: LogTag.api,
        color: LogColor.cyan,
      );
      logDebug(
        "📡 Type: ${response.data.runtimeType}",
        tag: LogTag.api,
        color: LogColor.cyan,
      );
      logDebug(
        "📡 [API] Collection: $collection",
        tag: LogTag.api,
        color: LogColor.cyan,
      );

      // 🕒 Timestamp setzen (um spätere Cache-Invalidierung zu ermöglichen)
      final collectionWithTimestamp = collection.copyWith(
        downloadedAt: DateTime.now(),
      );

      // 💾 Cache speichern
      // await _cacheClient.savePodcastCollection(collectionWithTimestamp);
      // await _cacheClient.savePodcastEpisodes(
      //   collectionId,
      //   collection.allEpisodes,
      // );

      return ApiResponse.success(collectionWithTimestamp);
    } catch (e) {
      return ApiResponse.error('[fetchPodcastEpisodes] $e');
    }
  }

  // 🔄 Fetch + Cache: Episoden einer bestimmten Collection
  @override
  Future<ApiResponse<List<PodcastEpisode>>> fetchPodcastEpisodes(
    int collectionId,
  ) async {
    try {
      // 1. 🔄 Zuerst lokalen Cache prüfen
      final cached = await _cacheClient.getPodcastEpisodes(collectionId);
      if (cached != null && cached.isNotEmpty) {
        return ApiResponse.success(cached);
      }

      // 2. 🌐 API-Fallback, wenn Cache leer
      final response = await _apiClient.getPodcastEpisodes(collectionId);

      // 3. 💾 Speichere neue Daten im Cache
      if (response is ApiResponseSuccess<List<PodcastEpisode>> &&
          response.data != null) {
        await _cacheClient.savePodcastEpisodes(collectionId, response.data!);

        logDebug(
          '[fetchPodcastEpisodes] Neue Episoden geladen & gespeichert.',
          color: LogColor.cyan,
          tag: LogTag.data,
        );
      }

      return response;
    } catch (e) {
      return ApiResponse.error('[fetchPodcastEpisodes] $e');
    }
  }

  // 🔄 Optional: Eine gesamte Podcast-Sammlung (z. B. aus Suche oder Empfehlung)
  @override
  Future<ApiResponse<PodcastCollection>> fetchPodcastCollection() async {
    try {
      // 1. 🔄 Versuche lokale Daten zu laden
      final cached = await _cacheClient.getPodcastCollection();

      if (cached != null) {
        return ApiResponse.success(cached);
      }

      // 2. 🌐 Fallback auf API-Abruf, wenn kein Cache
      final response = await _apiClient.getPodcastCollection();

      if (response is ApiResponseSuccess<PodcastCollection> &&
          response.data != null) {
        final collection = response.data!;

        await _cacheClient.savePodcastCollection(collection);

        logDebug(
          '[fetchPodcastCollection] Neue Sammlung gespeichert.',
          color: LogColor.green,
          tag: LogTag.data,
        );

        return ApiResponse.success(collection);
      }

      return response;
    } catch (e) {
      return ApiResponse.error('[fetchPodcastCollection] $e');
    }
  }

  // 🔹 Erweiterbar: Mehr Methoden wie fetchAllCollections(), etc.
}
