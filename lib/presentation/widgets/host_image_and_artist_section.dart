import 'package:flutter/material.dart';
import 'safe_image.dart';

/// Zeigt das Host-Bild (hostImage) und darunter den Artist-Namen auf der HostsPage an.
///
/// Das Bild wird nur angezeigt, wenn host.hostImage nicht leer ist.
/// Der Artist-Name wird mittig unterhalb des Bildes angezeigt, falls vorhanden.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostImageAndArtistSection extends StatelessWidget {
  final String collectionId;
  final String hostImage;
  final String? artistName;
  const HostImageAndArtistSection({
    super.key,
    required this.collectionId,
    required this.hostImage,
    this.artistName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // hostImage direkt unterhalb der Mission
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SafeImage(
                imageUrl:
                    'lib/tenants/collection_${collectionId}/assets/${hostImage}',
                width: 290,
                height: 220,
                fit: BoxFit.cover,
                isAsset: true,
              ),
            ),
          ),
        ),
        // Artist-Name mittig unterhalb des hostImage
        if (artistName != null && artistName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Center(
              child: Text(
                artistName!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
