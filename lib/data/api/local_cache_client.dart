// ...original code from storage_hold/lib/data/api/local_cache_client.dart...

// lib/data/api/local_cache_client.dart
// Hive-Verwaltung: cacheClientProvider

// 👀 Wenn du später auch CollectionIdStorage brauchst → baue ich dir gern den Teil extra raus.

import 'dart:convert';
import 'package:hive/hive.dart';

import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_episode_model.dart';

class LocalCacheClient {
  final Box _box;

  LocalCacheClient(this._box);

  Future<PodcastCollection?> getPodcastCollection() async {
    final jsonData = _box.get('podcastCollection');
    if (jsonData != null && jsonData is Map) {
      return PodcastCollection.fromJson(Map<String, dynamic>.from(jsonData));
    }
    return null;
  }

  Future<void> savePodcastCollection(PodcastCollection collection) async {
    await _box.put('podcastCollection', collection.toJson());
  }

  Future<List<PodcastEpisode>?> getPodcastEpisodes(int collectionId) async {
    final jsonData = _box.get('podcastEpisodes_$collectionId');
    if (jsonData != null && jsonData is List) {
      return jsonData.where((e) => e is Map || e is String).map((episode) {
        final decoded = episode is String ? jsonDecode(episode) : episode;
        return PodcastEpisode.fromJson(Map<String, dynamic>.from(decoded));
      }).toList();
    }
    return null;
  }

  Future<void> savePodcastEpisodes(
    int collectionId,
    List<PodcastEpisode> episodes,
  ) async {
    final jsonList = episodes.map((episode) => episode.toJson()).toList();
    await _box.put('podcastEpisodes_$collectionId', jsonList);
  }
}
