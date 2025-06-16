// lib/presentation/widgets/splash_cover_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../../core/utils/splash_cover_image_constants.dart';

class SplashCoverImage extends ConsumerStatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final Duration duration;
  final double scaleFactor;
  final bool showLabel;
  final bool forceAssetPath;

  const SplashCoverImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.duration = const Duration(milliseconds: 1200),
    this.scaleFactor = SplashCoverImageConstants.defaultScaleFactor,
    this.showLabel = false,
    this.forceAssetPath = false,
  });

  @override
  ConsumerState<SplashCoverImage> createState() => _SplashCoverImageState();
}

class _SplashCoverImageState extends ConsumerState<SplashCoverImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth * widget.scaleFactor;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeTransition(opacity: _fadeAnimation, child: _buildImage()),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Debug-Ausgabe entfernt
    // Wenn explizit gewünscht, immer assetPath verwenden
    if (widget.forceAssetPath &&
        widget.assetPath != null &&
        widget.assetPath!.isNotEmpty) {
      return Image.asset(
        widget.assetPath!,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    // Immer zuerst das collection-spezifische logo.png suchen
    final collectionId = ref.watch(collectionIdProvider);
    final loader = TenantAssetLoader(collectionId);
    final logoAssetPath = loader.imagePath();

    return Image.asset(
      logoAssetPath,
      fit: BoxFit.fitWidth,
      errorBuilder: (context, error, stackTrace) {
        if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
          return Image.asset(
            widget.assetPath!,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => _fallback(),
          );
        }
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.image, size: 100, color: Colors.grey[500]),
      ),
    );
  }
}

/*
SplashCoverImage(
  imageUrl: host.branding.logoUrl,
  assetPath: "assets/placeholder/logo.png",
),

🔁 Das Bild kommt sanft rein, ganz gleich ob Netzwerk oder lokal
    - und wenn gar nichts funktioniert, gibt’s den Icon-Fallback.
*/
