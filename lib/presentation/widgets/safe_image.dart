import 'package:flutter/material.dart';

/// Universelles Bild-Widget mit Fallback für Asset- und Netzwerkbilder.
class SafeImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isAsset;
  final Widget? fallback;

  const SafeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isAsset = false,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final Widget errorWidget = fallback ??
        Container(
          color: Colors.grey.shade200,
          width: width,
          height: height,
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 32),
        );
    if (isAsset) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    } else {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }
  }
}
