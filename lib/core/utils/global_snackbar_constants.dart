import 'package:flutter/material.dart';

/// Zentrale Konstanten und Hilfsfunktionen für GlobalSnackbarListener
class GlobalSnackbarConstants {
  static const double iconSize = 24;
  static const double fontSize = 20;
  static const int lineBreakThreshold = 30;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Color(0xFFFFA726); // Orange 400
  static const Color infoColor = Colors.blue;

  static TextStyle textStyle(Color color) => TextStyle(
        fontSize: fontSize,
        color: color,
      );

  /// Zeilenumbruch für lange Nachrichten
  static String formatMessageForLineBreak(String formatMes, {int? threshold}) {
    final t = threshold ?? lineBreakThreshold;
    if (formatMes.length < t) return formatMes;
    final delimiters = [':', '|', '/', ',', '!', '?'];
    for (var d in delimiters) {
      if (formatMes.contains(d)) {
        final parts = formatMes.split(d);
        if (parts.length > 1) {
          return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
        }
      }
    }
    return formatMes;
  }
}
