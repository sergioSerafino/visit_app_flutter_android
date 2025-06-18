import 'package:flutter/material.dart';

/// Zeigt die Mission-Beschreibung als großes Zitat auf der HostsPage an.
///
/// Wird nur angezeigt, wenn host.content.mission nicht leer ist.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostMissionSection extends StatelessWidget {
  final String mission;
  const HostMissionSection({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    // Mission-Beschreibung
    // Mission als großes Zitat
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          '„$mission“',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
