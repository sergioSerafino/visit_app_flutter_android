// lib/presentation/widgets/home_header.dart
// formatiertes Header-Widget

import 'package:flutter/material.dart';
import '../../core/utils/color_utils.dart';

Widget homeHeader(String hostName,
    {Color? textColor,
    Color? backgroundColor,
    BuildContext? context,
    bool overlayActive = false}) {
  final theme = context != null ? Theme.of(context) : null;
  final formattedHost = _formatHostNameForLineBreak(hostName);
  final double elevation = overlayActive ? 3.0 : 0.0;
  final Color effectiveBackground = (context != null && backgroundColor != null)
      ? flutterAppBarOverlayColorM3(context, backgroundColor,
          elevation: elevation)
      : (backgroundColor ?? Colors.transparent);

  return Material(
    color: effectiveBackground,
    elevation: 0, // AppBar-Optik, kein Schatten
    child: SizedBox(
      height: kToolbarHeight + 30, // gleiche Höhe wie AppBar
      child: Align(
        alignment: Alignment.centerLeft, // Links ausrichten
        child: RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 24, color: textColor ?? theme?.colorScheme.onPrimary),
            children: [
              const TextSpan(text: 'Visit'),
              TextSpan(
                text: "\n$formattedHost",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? theme?.colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String _formatHostNameForLineBreak(String hostName, {int threshold = 30}) {
  if (hostName.length < threshold) return hostName;

  final delimiters = [':', '-', '|', '/', ',']; // beliebig erweiterbar
  for (var d in delimiters) {
    if (hostName.contains(d)) {
      final parts = hostName.split(d);
      if (parts.length > 1) {
        return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
      }
    }
  }
  return hostName;
}

Color _darkenColor(Color color, double amount) {
  // amount: 0.0 (keine Änderung) bis 1.0 (schwarz)
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
