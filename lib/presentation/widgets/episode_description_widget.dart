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
    // Fallback: Wenn keine Beschreibung vorhanden, zeige einen dezenten Placeholder-Text
    final String displayText =
        (description == null || description!.trim().isEmpty)
            ? "Keine Beschreibung verfügbar."
            : description!;
    return Padding(
      padding: padding ?? EpisodeDescriptionWidgetConstants.defaultPadding,
      child: Text(
        displayText,
        style: style ??
            EpisodeDescriptionWidgetConstants.defaultStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}
