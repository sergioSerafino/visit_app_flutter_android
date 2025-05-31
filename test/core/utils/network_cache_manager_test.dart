import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:empty_flutter_template/core/utils/network_cache_manager.dart';

import 'network_cache_manager_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  group('NetworkCacheManager Tests', () {
    late MockCacheStorage mockStorage;
    late NetworkCacheManager cacheManager;

    setUp(() {
      mockStorage = MockCacheStorage();
      cacheManager = NetworkCacheManager(mockStorage);
    });

    test('should return true if resource is expired', () async {
      // Arrange
      const resourceKey = 'test_resource';
      when(
        mockStorage.get(resourceKey),
      ).thenAnswer((_) async => DateTime.now().subtract(Duration(days: 2)));

      // Act
      final isExpired = await cacheManager.isResourceExpired(
        resourceKey,
        Duration(days: 1),
      );

      // Assert
      expect(isExpired, true);
    });

    test('should update timestamp for a resource', () async {
      // Arrange
      const resourceKey = 'test_resource';
      when(mockStorage.put(resourceKey, any)).thenAnswer((_) async => {});

      // Act
      await cacheManager.updateTimeStamp(resourceKey);

      // Assert
      verify(mockStorage.put(resourceKey, any)).called(1);
    });
  });
}
