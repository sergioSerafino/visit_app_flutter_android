// lib/presentation/widgets/welcome_header.dart
// formatiertes Begrüßungs-Widget

import 'package:flutter/material.dart';

Widget welcomeHeader(String hostName) {
  final formattedHost = _formatHostNameForLineBreak(hostName);

  return RichText(
    textAlign: TextAlign.start,
    text: TextSpan(
      style: const TextStyle(fontSize: 24, color: Colors.black),
      children: [
        const TextSpan(text: 'Willkommen\nbei '),
        TextSpan(
          text: formattedHost,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
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
