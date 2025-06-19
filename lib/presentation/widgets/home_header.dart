// lib/presentation/widgets/home_header.dart
// formatiertes Header-Widget

import 'package:flutter/material.dart';

Widget homeHeader(String hostName,
    {Color? textColor,
    Color? backgroundColor,
    BuildContext? context,
    bool showOverlay = false}) {
  final theme = context != null ? Theme.of(context) : null;
  final formattedHost = _formatHostNameForLineBreak(hostName);

  return Stack(
    children: [
      Container(
        color: backgroundColor,
        child: SizedBox(
          height: kToolbarHeight + 30, // gleiche Höhe wie AppBar
          child: Align(
            alignment: Alignment.centerLeft, // Links ausrichten
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 24,
                    color: textColor ?? theme?.colorScheme.onPrimary),
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
      ),
      if (showOverlay && context != null && backgroundColor != null)
        Container(
          height: kToolbarHeight + 30,
          color: Colors.red.withOpacity(0.8), // Noch auffälligerer Overlay-Test
        ),
    ],
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
