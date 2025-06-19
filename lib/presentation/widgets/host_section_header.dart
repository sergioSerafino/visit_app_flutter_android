import 'package:flutter/material.dart';
import '../widgets/simple_section_header.dart';

/// Zeigt einen Abschnittsheader für die HostsPage an.
///
/// Kann für beliebige Überschriften wie 'Kontakt / Visit', 'Angebote & Portfolio' etc. verwendet werden.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostSectionHeader extends StatelessWidget {
  final String title;
  final bool showShadow;
  final Color? color;
  const HostSectionHeader(
      {super.key, required this.title, this.showShadow = false, this.color});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SimpleSectionHeader(
        title: title,
        showShadow: showShadow,
        color: color,
      ),
    );
  }
}
