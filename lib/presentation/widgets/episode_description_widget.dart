import 'package:flutter/material.dart';

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
      padding: padding ?? const EdgeInsets.only(top: 18),
      child: Text(
        description ?? "",
        style: style ?? TextStyle(
          fontSize: 22,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
