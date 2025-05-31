// lib/core/utils/tenant_asset_loader.dart

import 'package:flutter/services.dart' show rootBundle;

class TenantAssetLoader {
  final int? collectionId;

  const TenantAssetLoader(this.collectionId);

  /// Pfad-Vorlage für assets
  static const _basePath = 'assets/tenants';

  /// Versucht zuerst tenant-spezifisches Asset zu laden, sonst fallback
  Future<String> loadAsset(String filename) async {
    final tenantPath = '$_basePath/collection_$collectionId/assets/$filename';
    final fallbackPath = '$_basePath/common/assets/$filename';

    // checke ob Datei existiert (Flutter kann das nicht direkt, daher versuchen wir sie zu laden)
    try {
      await rootBundle.loadString(
        tenantPath,
      ); // klappt nur für .txt/json, für Images einfach Pfad zurückgeben
      return tenantPath;
    } catch (_) {
      return fallbackPath;
    }
  }

  /// Für Images: gibt immer zuerst den tenant-spezifischen Pfad zurück;
  /// die Fehlerbehandlung erfolgt UI-seitig z.B. über `errorBuilder`
  String imagePath(String filename) {
    if (collectionId != null) {
      return '$_basePath/collection_$collectionId/assets/$filename';
    } else {
      return '$_basePath/common/assets/$filename';
    }
  }
}
