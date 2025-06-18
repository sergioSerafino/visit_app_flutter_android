import 'package:flutter/material.dart';

/// Zeigt eine leere Platzhalter-Section am Ende der HostsPage an, um zusätzliches Scrollen zu ermöglichen.
///
/// Das Layout und die Höhe bleiben wie im Original.
class HostScrollSpacerSection extends StatelessWidget {
  const HostScrollSpacerSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Platzhalter für zusätzliches Scrollen
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) =>
            SizedBox(height: MediaQuery.of(context).size.height / 2),
      ),
    );
  }
}
