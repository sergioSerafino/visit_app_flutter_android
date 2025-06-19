import 'package:flutter/material.dart';

/// Flutter-konforme Overlay-Farbmischung für AppBar (Material 3).
/// Nutzt ElevationOverlay.applySurfaceTint wie Flutter intern.
Color flutterAppBarOverlayColorM3(BuildContext context, Color baseColor,
    {Color? surfaceTint, double elevation = 0}) {
  final theme = Theme.of(context);
  final Color tint = surfaceTint ?? theme.colorScheme.surfaceTint;
  // Nutzt Flutter-Logik für Material3-Overlay
  return ElevationOverlay.applySurfaceTint(baseColor, tint, elevation);
}
