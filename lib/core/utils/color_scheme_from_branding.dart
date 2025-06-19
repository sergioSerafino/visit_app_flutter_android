import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// Erstellt ein vollständiges ColorScheme aus 1-2 Branding-Farben (primary, secondary) und ThemeMode.
/// Nutzt FlexColorScheme für professionelle Material3-Paletten und automatische Nuancen.
ColorScheme generateColorSchemeFromBranding({
  required Color primary,
  Color? secondary,
  Brightness brightness = Brightness.light,
}) {
  // Fallback: Wenn keine secondary-Farbe, generiere eine abgeleitete.
  final Color sec = secondary ??
      HSLColor.fromColor(primary)
          .withHue((HSLColor.fromColor(primary).hue + 180) % 360)
          .withLightness(
              (HSLColor.fromColor(primary).lightness * 0.8).clamp(0.0, 1.0))
          .toColor();

  // FlexColorScheme erzeugt ein vollständiges ColorScheme inkl. Nuancen, Overlays, etc.
  final FlexSchemeColor flexScheme = FlexSchemeColor(
    primary: primary,
    secondary: sec,
  );

  return FlexColorScheme.light(
    colors: flexScheme,
    useMaterial3: true,
  ).toScheme.copyWith(brightness: brightness);
}
