import 'package:flutter/material.dart';

/// Widget für die Anzeige von Podcast-Metadaten (z.B. Titel, Artist) als mittig ausgerichtete Zeile.
class PodcastMetaInfoTile extends StatelessWidget {
  final String label;
  final String value;
  const PodcastMetaInfoTile(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      // child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child:
                Text('$label:', style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
      // ),
    );
  }
}
