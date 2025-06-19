import 'package:flutter/material.dart';
import '../widgets/simple_section_header.dart';
import '../../core/utils/color_utils.dart';

/// Zeigt einen Abschnittsheader für die HostsPage an.
///
/// Kann für beliebige Überschriften wie 'Kontakt / Visit', 'Angebote & Portfolio' etc. verwendet werden.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostSectionHeader extends StatelessWidget {
  final String title;
  final bool showShadow;
  final Color? color;
  final bool overlayActive;
  final Color? baseColor;
  const HostSectionHeader(
      {super.key,
      required this.title,
      this.showShadow = false,
      this.color,
      this.overlayActive = false,
      this.baseColor});

  @override
  Widget build(BuildContext context) {
    final double elevation = overlayActive ? 3.0 : 0.0;
    final Color effectiveColor = (baseColor != null)
        ? flutterAppBarOverlayColorM3(context, baseColor!, elevation: elevation)
        : (color ?? Theme.of(context).scaffoldBackgroundColor);
    return SliverPersistentHeader(
      pinned: true,
      delegate: SimpleSectionHeader(
        title: title,
        showShadow: showShadow,
        color: effectiveColor,
      ),
    );
  }
}
