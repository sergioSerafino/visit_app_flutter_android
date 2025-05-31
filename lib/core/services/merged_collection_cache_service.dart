// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu Caching, Collection-Merging und Teststrategie.
// Lessons Learned: MergedCollectionCacheService implementiert einen Hive-basierten Cache für gemergte PodcastHostCollection-Objekte mit TTL-Logik. Besonderheiten: Flexible Persistenz, einfache Invalidation, testbare API. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt einfache Erweiterung um weitere Cache-Strategien und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

// lib/core/services/merged_collection_cache_service.dart
// Hive-basierter Cache für gemergte PodcastHostCollection-Objekte

import 'package:hive/hive.dart';
import '../../domain/models/podcast_host_collection_model.dart';

class MergedCollectionCacheService {
  static const String _boxName = 'mergedCollectionsBox';
  static const Duration defaultTtl = Duration(hours: 12);

  Future<void> save(PodcastHostCollection collection) async {
    final box = await Hive.openBox(_boxName);
    await box.put(collection.collectionId.toString(), {
      'data': collection.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<PodcastHostCollection?> load(int collectionId) async {
    final box = await Hive.openBox(_boxName);
    final entry = box.get(collectionId.toString());
    if (entry == null) return null;
    return PodcastHostCollection.fromJson(
      Map<String, dynamic>.from(entry['data']),
    );
  }

  Future<bool> isFresh(int collectionId, {Duration? ttl}) async {
    final box = await Hive.openBox(_boxName);
    final entry = box.get(collectionId.toString());
    if (entry == null) return false;
    final timestamp = DateTime.tryParse(entry['timestamp'] ?? '');
    if (timestamp == null) return false;
    final expiry = ttl ?? defaultTtl;
    return DateTime.now().difference(timestamp) < expiry;
  }

  Future<void> invalidate(int collectionId) async {
    final box = await Hive.openBox(_boxName);
    await box.delete(collectionId.toString());
  }
}
