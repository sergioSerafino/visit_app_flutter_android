// lib/config/tenant_loader_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/utils/network_cache_manager.dart';
import '../../domain/models/host_model.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../core/logging/logger_config.dart';

class TenantLoaderService {
  static Future<Host> loadHostModel(String? collectionId) async {
    final tenant = collectionId != null ? 'collection_$collectionId' : 'common';
    logDebug('[DEBUG] TenantLoaderService: Lade HostModel für tenant=$tenant',
        tag: LogTag.ui);
    try {
      final json = await rootBundle.loadString(
        'lib/tenants/$tenant/host_model.json',
      );
      final host = Host.fromJson(jsonDecode(json));
      logDebug('[DEBUG] TenantLoaderService: HostModel geladen: $host',
          tag: LogTag.ui);
      logDebug(
          '[DEBUG] TenantLoaderService: Branding geladen: ${host.branding}',
          tag: LogTag.ui);
      return host;
    } catch (_) {
      logDebug(
          '[DEBUG] TenantLoaderService: Fallback auf common/host_model.json',
          tag: LogTag.ui);
      final fallback = await rootBundle.loadString(
        'lib/tenants/common/host_model.json',
      );
      final host = Host.fromJson(jsonDecode(fallback));
      logDebug('[DEBUG] TenantLoaderService: Fallback-HostModel geladen: $host',
          tag: LogTag.ui);
      logDebug(
          '[DEBUG] TenantLoaderService: Fallback-Branding geladen: ${host.branding}',
          tag: LogTag.ui);
      return host;
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
