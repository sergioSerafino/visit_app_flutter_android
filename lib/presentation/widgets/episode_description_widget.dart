import 'package:flutter/material.dart';
import '../../core/utils/episode_description_widget_constants.dart';

class EpisodeDescriptionWidget extends StatelessWidget {
  final String? description;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const EpisodeDescriptionWidget({
    super.key,
    required this.description,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EpisodeDescriptionWidgetConstants.defaultPadding,
      child: Text(
        description ?? "",
        style: style ??
            EpisodeDescriptionWidgetConstants.defaultStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}
