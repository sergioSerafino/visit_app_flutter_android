// lib/core/services/feature_flags_cache_service.dart
// Hive-basierter Cache für FeatureFlags
//
// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für FeatureFlags, Caching-Strategien und Teststrategie.
// Lessons Learned: Hive-basierter Cache für FeatureFlags, TTL-Logik und flexible Persistenz. Siehe zugehörige Provider und Tests.
// Hinweise: TTL, Persistenz und Testdaten beachten.

import 'package:hive/hive.dart';
import '../../domain/models/feature_flags_model.dart';

class FeatureFlagsCacheService {
  static const String _boxName = 'featureFlagsBox';
  static const Duration defaultTtl = Duration(hours: 12);

  Future<void> save(int collectionId, FeatureFlags flags) async {
    final box = await Hive.openBox(_boxName);
    await box.put(collectionId.toString(), {
      'data': flags.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<FeatureFlags?> load(int collectionId) async {
    final box = await Hive.openBox(_boxName);
    final entry = box.get(collectionId.toString());
    if (entry == null) return null;
    return FeatureFlags.fromJson(Map<String, dynamic>.from(entry['data']));
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
