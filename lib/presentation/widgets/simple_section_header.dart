import 'package:flutter/material.dart';

class SimpleSectionHeader extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;
  final bool showShadow;

  SimpleSectionHeader({
    required this.title,
    this.height = 56, // wie in EpisodeDetailPage
    this.showShadow = false,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: (overlapsContent || showShadow) ? 2 : 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Gradient-Linie nur anzeigen, wenn NICHT sticky (overlapsContent==false && !showShadow)
          if (!overlapsContent && !showShadow)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(
                          0x1A000000), // 10% Schwarz, ersetzt withOpacity(0.10)
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          // Header-Inhalt
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SimpleSectionHeader oldDelegate) {
    return title != oldDelegate.title ||
        height != oldDelegate.height ||
        showShadow != oldDelegate.showShadow;
  }
}
