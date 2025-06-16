import 'package:flutter/material.dart';

class EpisodeCoverWidget extends StatelessWidget {
  final String imageUrl;
  final double scaleFactor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  const EpisodeCoverWidget({
    super.key,
    required this.imageUrl,
    this.scaleFactor = 0.5,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: margin ?? const EdgeInsets.only(top: 32),
        decoration: BoxDecoration(
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(3, 10),
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          scale: 1 / scaleFactor,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
