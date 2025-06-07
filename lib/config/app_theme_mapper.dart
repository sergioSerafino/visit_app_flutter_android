// lib/config/app_theme_mapper.dart
// von Branding → ThemeData + ThemeMode

import 'package:flutter/material.dart';
import '../../domain/models/branding_model.dart';

class AppThemeMapper {
  static ThemeData fromBranding(Branding? branding) {
    debugPrint(
        '[DEBUG] AppThemeMapper.fromBranding: ${branding?.toString() ?? 'null'}');
    final primary = _parseHexColor(branding?.primaryColorHex) ??
        const Color(0xFFCCCCCC); // neutral hellgrau
    final secondary = _parseHexColor(branding?.secondaryColorHex) ??
        const Color(0xFFEEEEEE); // noch heller

    // Automatische Kontrastfarbe für Text/Icon auf primary
    final onPrimary = _getContrastColor(primary);
    final onSecondary = _getContrastColor(secondary);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        brightness: _themeModeToBrightness(branding?.themeMode),
      ),
      useMaterial3: true,
    );
  }

  /// Gibt automatisch Schwarz oder Weiß für ausreichenden Kontrast zurück
  static Color _getContrastColor(Color background) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
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
