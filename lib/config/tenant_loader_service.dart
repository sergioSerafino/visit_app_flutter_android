// lib/config/tenant_loader_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/utils/network_cache_manager.dart';
import '../../domain/models/host_model.dart';
import '../../domain/models/podcast_collection_model.dart';

class TenantLoaderService {
  static Future<Host> loadHostModel(String? collectionId) async {
    final tenant = collectionId != null ? 'collection_$collectionId' : 'common';
    final resourceKey = 'host_model_$tenant';

    final cacheManager = NetworkCacheManager(HiveCacheStorage());

    // Überprüfen, ob die Ressource veraltet ist
    if (!await cacheManager.isResourceExpired(
      resourceKey,
      const Duration(hours: 24),
    )) {
      return Host.empty(); // Verwende die leere Methode für Fallback
    }

    try {
      final json = await rootBundle.loadString(
        'assets/tenants/$tenant/host_model.json',
      );
      final host = Host.fromJson(jsonDecode(json));

      // Aktualisiere den TimeStamp nach erfolgreichem Abruf
      await cacheManager.updateTimeStamp(resourceKey);
      return host;
    } catch (_) {
      final fallback = await rootBundle.loadString(
        'assets/tenants/common/host_model.json',
      );
      return Host.fromJson(jsonDecode(fallback));
    }
  }

  static Future<PodcastCollection> loadPodcastCollection(
    String? collectionId,
  ) async {
    final tenant = collectionId != null ? 'collection_$collectionId' : 'common';
    final resourceKey = 'podcast_collection_$tenant';

    final cacheManager = NetworkCacheManager(HiveCacheStorage());

    // Überprüfen, ob die Ressource veraltet ist
    if (!await cacheManager.isResourceExpired(
      resourceKey,
      const Duration(hours: 24),
    )) {
      return PodcastCollection.empty();
    }

    try {
      final json = await rootBundle.loadString(
        'assets/tenants/$tenant/podcast_collection.json',
      );
      final collection = PodcastCollection.fromJson(jsonDecode(json));
      await cacheManager.updateTimeStamp(resourceKey);
      return collection;
    } catch (_) {
      final fallback = await rootBundle.loadString(
        'assets/tenants/common/podcast_collection.json',
      );
      return PodcastCollection.fromJson(jsonDecode(fallback));
    }
  }
}
