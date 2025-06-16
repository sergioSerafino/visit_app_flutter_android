// lib/presentation/widgets/cover_image_widget.dart
// lib/presentation/widgets/cover_placeholder.dart

import 'package:flutter/material.dart';
import '../../core/utils/cover_image_widget_constants.dart';

class CoverImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double scaleFactor;
  final bool showLabel;

  const CoverImageWidget({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.scaleFactor = 0.95,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth * scaleFactor;

    final iconSize = size * 0.55;
    final labelBottomOffset = size * 0.13;
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: CoverImageWidgetConstants.backgroundColor,
          borderRadius: BorderRadius.circular(CoverImageWidgetConstants.borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildContent(iconSize, labelBottomOffset, theme),
      ),
    );
  }

  Widget _buildContent(
      double iconSize, double labelBottomOffset, ThemeData theme) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(iconSize, labelBottomOffset, theme),
      );
    }
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(iconSize, labelBottomOffset, theme),
      );
    }
    return _buildFallback(iconSize, labelBottomOffset, theme);
  }

  Widget _buildFallback(
      double iconSize, double labelBottomOffset, ThemeData theme) {
    return Stack(
      children: [
        Center(
          child: Icon(
            Icons.podcasts,
            size: iconSize,
            color: CoverImageWidgetConstants.iconColor,
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
                  color: CoverImageWidgetConstants.labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: iconSize * 0.25,
                  shadows: const [
                    Shadow(
                      blurRadius: CoverImageWidgetConstants.labelShadowBlur,
                      color: CoverImageWidgetConstants.labelShadowColor,
                      offset: CoverImageWidgetConstants.labelShadowOffset,
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
