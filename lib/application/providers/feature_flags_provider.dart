// filepath: lib/application/providers/feature_flags_provider.dart
// StateNotifierProvider für FeatureFlags mit Caching und Fallback

// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für FeatureFlags, Caching, Fallback-Strategien und Teststrategie.
// Lessons Learned: FeatureFlags mit Caching, Fallback und StateNotifier-Pattern für flexible Feature-Steuerung. Siehe auch feature_flags_cache_service.dart.
// Hinweise: Fallback-Logik, Persistenz und Testdaten beachten.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/feature_flags_cache_service.dart';
import '../../domain/models/feature_flags_model.dart';
import 'collection_provider.dart';

final featureFlagsCacheServiceProvider = Provider(
  (ref) => FeatureFlagsCacheService(),
);

final featureFlagsProvider =
    StateNotifierProvider.autoDispose<FeatureFlagsNotifier, FeatureFlags>(
  (
    ref,
  ) {
    final collectionId = ref.watch(collectionIdProvider);
    final cacheService = ref.watch(featureFlagsCacheServiceProvider);
    return FeatureFlagsNotifier(collectionId, cacheService);
  },
);

class FeatureFlagsNotifier extends StateNotifier<FeatureFlags> {
  final int collectionId;
  final FeatureFlagsCacheService cacheService;

  FeatureFlagsNotifier(this.collectionId, this.cacheService)
      : super(FeatureFlags.empty()) {
    _load();
  }

  Future<void> _load() async {
    if (await cacheService.isFresh(collectionId)) {
      final cached = await cacheService.load(collectionId);
      if (cached != null) {
        state = cached;
        return;
      }
    }
    // TODO: Fallback/Fetch aus gemergten Daten oder API
    // state = ...
  }

  Future<void> setFlags(FeatureFlags flags) async {
    state = flags;
    await cacheService.save(collectionId, flags);
  }
}
