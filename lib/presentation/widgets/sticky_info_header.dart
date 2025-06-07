// lib/presentation/widgets/sticky_info_header.dart
import 'package:flutter/material.dart';

class StickyInfoHeader extends SliverPersistentHeaderDelegate {
  final String duration;
  final String releaseDate;
  final Widget? extraContent;

  StickyInfoHeader({
    required this.duration,
    required this.releaseDate,
    this.extraContent,
  });

  // Dynamische Höhe: Basis + extraContent (Buttons/Slider)
  static const double _baseHeight = 44;
  static const double _maxExtraHeight = 44;

  @override
  double get minExtent => _baseHeight + _maxExtraHeight;

  @override
  double get maxExtent => _baseHeight + _maxExtraHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Verfügbar seit $releaseDate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(140), // dezenter
                          ),
                        ),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(140), // dezenter
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    // color: Color.fromRGBO(224, 224, 224, 1),
                    // thickness: 2,
                    // height: 4, // Abstand nach der Linie komplett entfernt
                    //),
                    // Durch Theme-Farbe ersetzen:
                    color: Colors.transparent, // wird durch Theme überschrieben
                    thickness: 2,
                    height: 4,
                  ),
                  if (extraContent != null) ...[extraContent!],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyInfoHeader oldDelegate) {
    return duration != oldDelegate.duration ||
        releaseDate != oldDelegate.releaseDate ||
        extraContent != oldDelegate.extraContent;
  }
}
