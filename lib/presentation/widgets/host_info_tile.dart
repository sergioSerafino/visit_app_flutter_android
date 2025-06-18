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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text('$label:',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
