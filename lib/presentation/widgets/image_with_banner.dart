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
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          // Banner-Overlay
          Positioned(
            top: 3, //10
            left: 3, //10
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(
                  95,
                ), // Schwarzer Hintergrund mit Transparenz
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                label.toUpperCase(), // Automatisch in Capslock
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  //fontSize: 14,
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
  Widget _buildPlaceholder() {
    return Container(
      width: 250,
      height: 250,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 80, color: Colors.grey[500]),
    );
  }
}
