// /config/app_theme.dart
// zentrale Theme-Zuordnung (Branding -> ThemeData)

import 'package:flutter/material.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Color(0xFF00D6F2),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple[200]!,
      secondary: const Color(0xFF00D6F2),
    ),
  );
}
