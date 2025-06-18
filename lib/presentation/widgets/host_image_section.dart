import 'package:flutter/material.dart';

/// Zeigt das Host-Bild (hostImage) unterhalb der Mission auf der HostsPage an.
///
/// Wird nur angezeigt, wenn host.hostImage nicht leer ist.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostImageSection extends StatelessWidget {
  final String collectionId;
  final String hostImage;
  const HostImageSection(
      {super.key, required this.collectionId, required this.hostImage});

  @override
  Widget build(BuildContext context) {
    // hostImage direkt unterhalb der Mission
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'lib/tenants/collection_${collectionId}/assets/${hostImage}',
            width: 290,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
