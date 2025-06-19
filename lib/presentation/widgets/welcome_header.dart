// lib/presentation/widgets/welcome_header.dart
// formatiertes Begrüßungs-Widget

import 'package:flutter/material.dart';

Widget welcomeHeader(String hostName,
    {Color? textColor, Color? backgroundColor, required BuildContext context}) {
  final theme = Theme.of(context);
  final formattedHost = _formatHostNameForLineBreak(hostName);

  return Container(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: 24,
            color: textColor ??
                theme.colorScheme.onSurface), // onSurface für Lesbarkeit
        children: [
          const TextSpan(text: 'Willkommen bei\n'),
          TextSpan(
            text: formattedHost,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor ??
                    theme.colorScheme.onSurface), // auch hier onSurface
          ),
        ],
      ),
    ),
  );
}

String _formatHostNameForLineBreak(String hostName, {int threshold = 30}) {
  if (hostName.length < threshold) return hostName;

  final delimiters = [':', '-', '|', '/']; // beliebig erweiterbar
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
