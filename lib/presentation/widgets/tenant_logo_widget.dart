import 'package:flutter/material.dart';
import '../../core/utils/tenant_asset_loader.dart';

/// Zeigt das assetLogo für einen Tenant an, mit Fallback auf das Standard-Logo.
class TenantLogoWidget extends StatelessWidget {
  final int collectionId;
  final String? assetLogo;
  final double scaleFactor;
  final Duration duration;

  const TenantLogoWidget({
    super.key,
    required this.collectionId,
    this.assetLogo,
    this.scaleFactor = 0.5,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    final assetLogoPath =
        TenantAssetLoader(collectionId).assetLogoPath(assetLogo);
    final size = MediaQuery.of(context).size.width * scaleFactor;
    return Center(
      child: SizedBox(
        width: size * 1.25,
        height: size * 0.6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor:
                  1.0, // z.B. 70% der Bildhöhe anzeigen (oben und unten croppen)
              child: Image.asset(
                assetLogoPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback auf Standard-Logo
                  final fallbackPath =
                      TenantAssetLoader(collectionId).imagePath();
                  return Image.asset(
                    fallbackPath,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image,
                            size: 100, color: Colors.grey[500]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
