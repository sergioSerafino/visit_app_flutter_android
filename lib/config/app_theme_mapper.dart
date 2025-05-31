// lib/config/app_theme_mapper.dart
// von Branding → ThemeData + ThemeMode

import 'package:flutter/material.dart';
import '../../domain/models/branding_model.dart';

class AppThemeMapper {
  static ThemeData fromBranding(Branding? branding) {
    final primary =
        _parseHexColor(branding?.primaryColorHex) ?? Colors.deepPurple;
    final secondary =
        _parseHexColor(branding?.secondaryColorHex) ?? const Color(0xFF00D6F2);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        brightness: _themeModeToBrightness(branding?.themeMode),
      ),
      useMaterial3: true,
    );
  }

  static ThemeMode toThemeMode(String? rawMode) {
    switch (rawMode?.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static Brightness _themeModeToBrightness(String? rawMode) {
    switch (toThemeMode(rawMode)) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      default:
        return Brightness.light; // system → hell als Fallback
    }
  }

  static Color? _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
