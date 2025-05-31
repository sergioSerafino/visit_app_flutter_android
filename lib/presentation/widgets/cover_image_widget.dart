// lib/presentation/widgets/cover_image_widget.dart
// lib/presentation/widgets/cover_placeholder.dart

import 'package:flutter/material.dart';

class CoverImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double scaleFactor;
  final bool showLabel;

  const CoverImageWidget({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.scaleFactor = 0.95,
    this.showLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth * scaleFactor;

    final iconSize = size * 0.55;
    final labelBottomOffset = size * 0.13;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildContent(iconSize, labelBottomOffset),
      ),
    );
  }

  Widget _buildContent(double iconSize, double labelBottomOffset) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(iconSize, labelBottomOffset),
      );
    }
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(iconSize, labelBottomOffset),
      );
    }
    return _buildFallback(iconSize, labelBottomOffset);
  }

  Widget _buildFallback(double iconSize, double labelBottomOffset) {
    return Stack(
      children: [
        Center(
          child: Icon(
            Icons.podcasts,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        if (showLabel)
          Positioned(
            left: 0,
            right: 0,
            bottom: labelBottomOffset,
            child: Center(
              child: Text(
                'Podcast',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: iconSize * 0.25,
                  shadows: [
                    const Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
