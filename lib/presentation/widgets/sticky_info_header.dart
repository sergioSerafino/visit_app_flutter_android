// lib/presentation/widgets/sticky_info_header.dart
import 'package:flutter/material.dart';
import '../../core/utils/sticky_info_header_constants.dart';

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
  static const double _baseHeight = StickyInfoHeaderConstants.baseHeight;
  static const double _maxExtraHeight =
      StickyInfoHeaderConstants.maxExtraHeight;

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
              padding: StickyInfoHeaderConstants.horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: StickyInfoHeaderConstants.rowPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Verfügbar seit $releaseDate",
                          style: StickyInfoHeaderConstants.releaseDateStyle
                              .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(100),
                          ),
                        ),
                        Text(
                          duration,
                          style:
                              StickyInfoHeaderConstants.durationStyle.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: StickyInfoHeaderConstants.dividerColor,
                    thickness: StickyInfoHeaderConstants.dividerThickness,
                    height: StickyInfoHeaderConstants.dividerHeight,
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
