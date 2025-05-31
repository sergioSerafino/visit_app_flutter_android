import 'package:hive/hive.dart';

abstract class CacheStorage {
  Future<DateTime?> get(String key);
  Future<void> put(String key, DateTime value);
}

class HiveCacheStorage implements CacheStorage {
  static const String _cacheBoxName = 'network_cache';

  @override
  Future<DateTime?> get(String key) async {
    final box = await Hive.openBox<DateTime>(_cacheBoxName);
    return box.get(key);
  }

  @override
  Future<void> put(String key, DateTime value) async {
    final box = await Hive.openBox<DateTime>(_cacheBoxName);
    await box.put(key, value);
  }
}

class NetworkCacheManager {
  final CacheStorage storage;

  NetworkCacheManager(this.storage);

  /// Prüft, ob eine Ressource veraltet ist.
  Future<bool> isResourceExpired(
    String resourceKey,
    Duration expiryDuration,
  ) async {
    final lastFetched = await storage.get(resourceKey);
    if (lastFetched == null) return true; // Kein TimeStamp vorhanden
    return DateTime.now().difference(lastFetched) > expiryDuration;
  }

  /// Aktualisiert den TimeStamp einer Ressource.
  Future<void> updateTimeStamp(String resourceKey) async {
    await storage.put(resourceKey, DateTime.now());
  }

  /// Holt den TimeStamp einer Ressource.
  Future<DateTime?> getTimeStamp(String resourceKey) async {
    return storage.get(resourceKey);
  }
}
