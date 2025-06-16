import 'package:flutter/material.dart';

class EpisodeTitleWidget extends StatelessWidget {
  final String title;
  final double opacity;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const EpisodeTitleWidget({
    super.key,
    required this.title,
    this.opacity = 1.0,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Text(
          title,
          style: style ?? TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
