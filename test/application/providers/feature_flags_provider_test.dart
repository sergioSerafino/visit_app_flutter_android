import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/application/providers/feature_flags_provider.dart';
import 'package:empty_flutter_template/application/providers/collection_provider.dart';
import 'package:empty_flutter_template/domain/models/feature_flags_model.dart';
import 'package:empty_flutter_template/core/services/feature_flags_cache_service.dart';
import 'package:empty_flutter_template/core/services/collection_id_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeCacheService extends FeatureFlagsCacheService {
  FeatureFlags? _flags;
  bool _fresh = false;
  @override
  Future<bool> isFresh(int collectionId, {Duration? ttl}) async => _fresh;
  @override
  Future<FeatureFlags?> load(int collectionId) async => _flags;
  @override
  Future<void> save(int collectionId, FeatureFlags flags) async {
    _flags = flags;
    _fresh = true;
  }

  void setFresh(bool fresh) => _fresh = fresh;
  void setFlags(FeatureFlags? flags) => _flags = flags;
}

class TestCollectionIdStorage implements CollectionIdStorage {
  int? _id;
  @override
  Future<int?> load() async => _id;
  @override
  Future<void> save(int id) async => _id = id;
}

class TestCollectionIdNotifier extends CollectionIdNotifier {
  TestCollectionIdNotifier(CollectionIdStorage storage) : super(storage) {
    state = 123;
  }
}

void main() {
  group('FeatureFlagsProvider Fallback/Placeholder', () {
    late Directory tempDir;
    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
    });
    tearDown(() async {
      await tempDir.delete(recursive: true);
    });
    test('Fallback auf Placeholder, wenn kein Cache vorhanden', () async {
      final fakeCache = FakeCacheService();
      fakeCache.setFresh(false);
      fakeCache.setFlags(null);
      final testStorage = TestCollectionIdStorage();
      final container = ProviderContainer(
        overrides: [
          featureFlagsCacheServiceProvider.overrideWithValue(fakeCache),
          collectionIdStorageProvider.overrideWithValue(testStorage),
          collectionIdProvider.overrideWith(
            (ref) => TestCollectionIdNotifier(testStorage),
          ),
        ],
      );
      final flags = container.read(featureFlagsProvider);
      expect(flags, FeatureFlags.empty());
    });
    test('Lädt Flags aus Cache, wenn frisch', () async {
      final fakeCache = FakeCacheService();
      final testFlags = FeatureFlags(showPortfolioTab: true);
      fakeCache.setFresh(true);
      fakeCache.setFlags(testFlags);
      final testStorage = TestCollectionIdStorage();
      final container = ProviderContainer(
        overrides: [
          featureFlagsCacheServiceProvider.overrideWithValue(fakeCache),
          collectionIdStorageProvider.overrideWithValue(testStorage),
          collectionIdProvider.overrideWith(
            (ref) => TestCollectionIdNotifier(testStorage),
          ),
        ],
      );
      final completer = Completer<void>();
      late FeatureFlags latestFlags;
      final sub = container.listen<FeatureFlags>(featureFlagsProvider, (
        prev,
        next,
      ) {
        latestFlags = next;
        if (next.showPortfolioTab == true) {
          completer.complete();
        }
      }, fireImmediately: true);
      await completer.future.timeout(Duration(seconds: 1));
      expect(latestFlags.showPortfolioTab, true);
      sub.close();
    });
  });
}
