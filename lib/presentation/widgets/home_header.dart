// lib/presentation/widgets/home_header.dart
// formatiertes Header-Widget

import 'package:flutter/material.dart';

Widget homeHeader(String hostName,
    {Color? textColor, Color? backgroundColor, BuildContext? context}) {
  final theme = context != null ? Theme.of(context) : null;
  final formattedHost = _formatHostNameForLineBreak(hostName);

  return Container(
    color: backgroundColor ?? theme?.colorScheme.primary,
    child: RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
            fontSize: 24, color: textColor ?? theme?.colorScheme.onPrimary),
        children: [
          const TextSpan(text: 'Visit'),
          TextSpan(
            text: "\n" + formattedHost,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor ?? theme?.colorScheme.onPrimary),
          ),
        ],
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
