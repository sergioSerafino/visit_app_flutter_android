// lib/core/services/generic_paging_cache_service.dart
// Generischer Hive-basierter Paging-Cache für beliebige Listen (z.B. Episoden, Suchergebnisse, Hosts)
// T muss von/toJson unterstützen

import 'package:hive/hive.dart';

typedef FromJson<T> = T Function(Map<String, dynamic>);

class GenericPagingCacheService<T> {
  final String boxName;
  final FromJson<T> fromJson;
  final Duration defaultTtl;

  GenericPagingCacheService({
    required this.boxName,
    required this.fromJson,
    this.defaultTtl = const Duration(hours: 1),
  });

  String _key(String id, int pageIndex) => '${id}_$pageIndex';

  Future<void> savePage(
    String id,
    int pageIndex,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final box = await Hive.openBox(boxName);
    await box.put(_key(id, pageIndex), {
      'data': items.map(toJson).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<T>?> loadPage(String id, int pageIndex) async {
    final box = await Hive.openBox(boxName);
    final entry = box.get(_key(id, pageIndex));
    if (entry == null) return null;
    final data = entry['data'] as List<dynamic>?;
    if (data == null) return null;
    return data.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<bool> isPageFresh(String id, int pageIndex, {Duration? ttl}) async {
    final box = await Hive.openBox(boxName);
    final entry = box.get(_key(id, pageIndex));
    if (entry == null) return false;
    final timestamp = DateTime.tryParse(entry['timestamp'] ?? '');
    if (timestamp == null) return false;
    final expiry = ttl ?? defaultTtl;
    return DateTime.now().difference(timestamp) < expiry;
  }

  Future<void> invalidatePage(String id, int pageIndex) async {
    final box = await Hive.openBox(boxName);
    await box.delete(_key(id, pageIndex));
  }
}
