import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Zeigt das Last-Updated-Datum auf der HostsPage an.
///
/// Wird nur angezeigt, wenn host.lastUpdated nicht null ist.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostLastUpdatedSection extends StatelessWidget {
  final DateTime lastUpdated;
  const HostLastUpdatedSection({super.key, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    // Last Updated
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Aktualisiert: '
                '${DateFormat('dd.MM.yyyy', 'de_DE').format(lastUpdated.toLocal())}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
