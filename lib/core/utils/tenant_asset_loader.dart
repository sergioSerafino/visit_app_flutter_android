// lib/core/utils/tenant_asset_loader.dart

import 'package:flutter/services.dart' show rootBundle;

class TenantAssetLoader {
  final int? collectionId;

  const TenantAssetLoader(this.collectionId);

  /// Pfad-Vorlage für assets
  static const _basePath = 'lib/tenants';

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

  /// Für Images: gibt immer zuerst den tenant-spezifischen Pfad zu 'logo.png' zurück;
  /// die Fehlerbehandlung erfolgt UI-seitig z.B. über `errorBuilder`
  String imagePath() {
    const filename = 'logo.png';
    if (collectionId != null) {
      return 'lib/tenants/collection_$collectionId/assets/$filename';
    } else {
      return 'lib/tenants/common/assets/$filename';
    }
  }

  /// Gibt den Pfad zum assetLogo (falls vorhanden) im Asset-Ordner des Tenants zurück.
  /// Wenn assetLogo leer oder null, wird wie bisher logo.png verwendet.
  String assetLogoPath(String? assetLogo) {
    if (assetLogo != null && assetLogo.isNotEmpty) {
      // Wenn assetLogo ein relativer Pfad ist, ergänze ggf. den Tenant-Ordner
      if (assetLogo.startsWith('/')) {
        // Absolute Pfade werden direkt verwendet
        return assetLogo;
      } else if (collectionId != null) {
        // Relativer Pfad im Tenant-Ordner
        return 'lib/tenants/collection_$collectionId/assets/$assetLogo';
      } else {
        // Relativer Pfad im Common-Ordner
        return 'lib/tenants/common/assets/$assetLogo';
      }
    }
    // Fallback: Standard-Logo
    return imagePath();
  }
}
