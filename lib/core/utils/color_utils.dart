import 'package:flutter/material.dart';

/// Flutter-konforme Overlay-Farbmischung für AppBar (Material 3).
/// Nutzt Color.alphaBlend und surfaceTint mit exakt berechnetem Alpha.
Color flutterAppBarOverlayColor(BuildContext context, Color baseColor,
    {double overlayOpacity = 0.08}) {
  final Color surfaceTint = Theme.of(context).colorScheme.surfaceTint;
  // Flutter verwendet für Overlay typischerweise 8% Opazität (0.08)
  final int alpha = (overlayOpacity * 255).round();
  final Color overlay = surfaceTint.withAlpha(alpha);
  return Color.alphaBlend(overlay, baseColor);
}
