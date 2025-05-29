// lib/core/messaging/snackbar_event.dart
import 'package:flutter/material.dart';

// Typen für verschiedene Snackbar-Varianten
enum SnackbarType { info, success, error, warning }

// Datenmodell für einen Snackbar-Event
class SnackbarEvent {
  final String message;
  final SnackbarType type;
  final Duration duration;
  final IconData? icon;
  final String? emoji; // Optionales Emoji als Icon-Ersatz
  final int? delayMs; // Optional: Verzögerung in Millisekunden

  SnackbarEvent({
    required this.message,
    this.type = SnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.icon,
    this.emoji,
    this.delayMs,
  });
}
