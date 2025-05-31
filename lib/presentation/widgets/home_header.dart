// lib/presentation/widgets/home_header.dart
// formatiertes Header-Widget

import 'package:flutter/material.dart';

Widget homeHeader(String hostName) {
  final formattedHost = _formatHostNameForLineBreak(hostName);

  return RichText(
    textAlign: TextAlign.start,
    text: TextSpan(
      style: const TextStyle(fontSize: 24, color: Colors.black),
      children: [
        const TextSpan(text: 'Visit'),
        TextSpan(
          text: "\n" + formattedHost,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
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
