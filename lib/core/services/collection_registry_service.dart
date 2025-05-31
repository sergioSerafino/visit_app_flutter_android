// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu Collection-Registry, Validierung und Caching.
// Lessons Learned: CollectionRegistryService verwaltet und validiert zentral alle CollectionIds, nutzt Hive für lokalen Cache und unterstützt Remote-Synchronisierung. Besonderheiten: TTL-Logik, Fallback-Strategie, Debug-Ausgaben. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur ermöglicht einfache Erweiterung um weitere Validierungsregeln und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.
//
// filepath: lib/core/services/collection_registry_service.dart
// Zentrale Verwaltung und Validierung aller verfügbaren CollectionIds

import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CollectionRegistryService {
  static const String _boxName = 'collectionRegistryBox';
  static const String _key = 'registry';
  static const Duration defaultTtl = Duration(hours: 24);
  final Dio dio;
  final String remoteUrl;

  CollectionRegistryService({required this.dio, required this.remoteUrl});

  Future<List<int>> fetchRemote() async {
    final response = await dio.get(remoteUrl);
    final List<dynamic> ids = response.data['collectionIds'] ?? [];
    return ids
        .map((e) => int.tryParse(e.toString()) ?? -1)
        .where((id) => id > 0)
        .toList();
  }

  Future<void> save(List<int> ids) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, {
      'data': ids,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<int>?> load() async {
    final box = await Hive.openBox(_boxName);
    final entry = box.get(_key);
    if (entry == null) return null;
    final data = entry['data'] as List<dynamic>?;
    if (data == null) return null;
    return data
        .map((e) => int.tryParse(e.toString()) ?? -1)
        .where((id) => id > 0)
        .toList();
  }

  Future<bool> isFresh({Duration? ttl}) async {
    final box = await Hive.openBox(_boxName);
    final entry = box.get(_key);
    if (entry == null) return false;
    final timestamp = DateTime.tryParse(entry['timestamp'] ?? '');
    if (timestamp == null) return false;
    final now = DateTime.now();
    final effectiveTtl = ttl ?? defaultTtl;
    return now.difference(timestamp) < effectiveTtl;
  }

  Future<List<int>> getRegistry() async {
    if (await isFresh()) {
      final cached = await load();
      if (cached != null) return cached;
    }
    try {
      final remote = await fetchRemote();
      await save(remote);
      return remote;
    } catch (_) {
      final fallback = await load();
      if (fallback != null) return fallback;
      return [];
    }
  }

  Future<bool> isValid(int collectionId) async {
    final registry = await getRegistry();
    final valid = registry.contains(collectionId);
    if (!valid && kDebugMode) {
      // Transparente Dev-Fehlerausgabe (z. B. Logging, Snackbar nur im Debug-Mode)
      print('[DEBUG] Ungültige CollectionId: $collectionId nicht in Registry!');
    }
    return valid;
  }
}
