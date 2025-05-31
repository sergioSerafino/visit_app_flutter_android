// ../application/config/tenant_branding_service.dart

import '../core/utils/tenant_asset_loader.dart';
import '../domain/models/branding_model.dart';

class TenantBrandingService {
  final int? collectionId;

  const TenantBrandingService(this.collectionId);

  /// Splash-/Startlogo (z. B. für LaunchScreen)
  String splashLogo() {
    final loader = TenantAssetLoader(collectionId);
    return loader.imagePath("opalia_talk_reduced.png");
  }

  /// Normales App-Branding-Logo (z. B. für AppBar)
  String logoForTenant() {
    final loader = TenantAssetLoader(collectionId);
    return loader.imagePath("logo.png");
  }

  /// Optionales Cover / großes visuelles Branding
  String coverImage() {
    final loader = TenantAssetLoader(collectionId);
    return loader.imagePath("opalia_talk_logo.png");
  }

  /// Branding-Fallback z. B. wenn keine Konfig geladen wurde
  Branding defaultBranding() {
    return const Branding(
      primaryColorHex: "#673AB7", // deepPurple
      secondaryColorHex: "#00D6F2",
      themeMode: "light",
    );
  }
}
