import 'package:flutter/material.dart';

/// Zeigt eine InfoTile (Label/Wert-Paar) auf der HostsPage an.
///
/// Wird für verschiedene Informationen wie E-Mail, Website, Impressum etc. verwendet.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostInfoTile extends StatelessWidget {
  final String label;
  final String value;
  const HostInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // InfoTile: Einfache Zeile für Label/Wert-Paare, wie in HostCard genutzt.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 160,
              child: Text('$label:',
                  style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(
              child: Text(value, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
