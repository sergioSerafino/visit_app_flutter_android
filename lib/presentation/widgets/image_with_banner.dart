// lib/presentation/widgets/image_with_banner.dart
// Widget für ein Image mit einem Podcast-Genre-Text davor
import 'package:flutter/material.dart';

class ImageWithBanner extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;

  const ImageWithBanner({
    super.key,
    required this.imageUrl,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap, // 👈 macht das ganze Widget tappable
      child: Stack(
        alignment: Alignment.topRight, // Position des Labels
        children: [
          // ENTWEDER: Bild aus URL ODER: Platzhalter-Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.trim().isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(theme),
                  )
                : _buildPlaceholder(theme),
          ),
          // Banner-Overlay
          Positioned(
            top: 3, //10
            left: 3, //10
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(90),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                label.toUpperCase(), // Automatisch in Capslock
                style: TextStyle(
                  color: Colors.white,
                  // color: theme.colorScheme.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Methode für Platzhalter-Icon
  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      width: 250,
      height: 250,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 80, color: Colors.grey[500]),
    );
  }
}
