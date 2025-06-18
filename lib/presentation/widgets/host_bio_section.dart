import 'package:flutter/material.dart';

/// Bio-Beschreibung des Hosts
///
/// Wird auf der HostsPage unterhalb von Mission und Bild angezeigt.
/// Layout, Padding und Stil wie im Original belassen.
class HostBioSection extends StatelessWidget {
  final String bio;
  const HostBioSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    // Bio-Beschreibung
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Text(
        bio,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onBackground,
            ),
        // textAlign: TextAlign.justify,
        softWrap: true,
        maxLines: 15, // Optional: Begrenzung, kann angepasst werden
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
