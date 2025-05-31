// lib/presentation/widgets/splash_cover_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';
import '../../core/utils/tenant_asset_loader.dart';

class SplashCoverImage extends ConsumerStatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final Duration duration;
  final double scaleFactor;
  final bool showLabel;

  const SplashCoverImage({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.duration = const Duration(milliseconds: 1200),
    this.scaleFactor = 0.5,
    this.showLabel = false,
  }) : super(key: key);

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
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      return Image.asset(
        widget.assetPath!,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    // 🔁 Fallback auf tenant-Asset
    final collectionId = ref.watch(collectionIdProvider);
    final loader = TenantAssetLoader(collectionId);
    final dynamicPath = loader.imagePath("opalia_talk_logo.png");

    return _fallback();
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
