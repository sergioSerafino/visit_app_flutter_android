import 'package:flutter/material.dart';
import '../widgets/splash_cover_image.dart';
import '../../core/utils/tenant_asset_loader.dart';

/// Zeigt das Logo (SplashCoverImage) nach der Bio auf der HostsPage an.
///
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostLogoImageSection extends StatelessWidget {
  final int collectionId;
  final String? logoUrl;
  const HostLogoImageSection(
      {super.key, required this.collectionId, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    // logo (SplashCoverImage) nach der Bio
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.28,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Align(
              alignment: Alignment.center,
              heightFactor: 0.7, // schneidet oben und unten ab
              child: SplashCoverImage(
                assetPath: TenantAssetLoader(collectionId).imagePath(),
                imageUrl: logoUrl,
                scaleFactor: 1.0,
                duration: const Duration(milliseconds: 800),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
