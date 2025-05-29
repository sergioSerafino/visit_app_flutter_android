import 'package:flutter/material.dart';
import 'snackbar_event.dart';
import 'emoji.dart';

class SnackbarEventFactory {
  final Map<String, dynamic> _config;

  SnackbarEventFactory(this._config);

  SnackbarEvent create(String eventKey, {Map<String, String>? args}) {
    final event = _config[eventKey];
    if (event == null) {
      throw ArgumentError('Unbekannter Snackbar-Key: $eventKey');
    }
    String? message = event['message'] as String? ?? eventKey;
    message = _interpolate(message, args ?? {});
    IconData? icon;
    String? emoji;
    // Emoji aus Enum, falls als Name angegeben
    final iconValue = event['icon'] as String?;
    if (iconValue != null && Emoji.values.any((e) => e.name == iconValue)) {
      emoji = Emoji.values.firstWhere((e) => e.name == iconValue).char;
    } else {
      emoji = iconValue;
    }
    final duration = _parseDuration(event['duration']);
    int? delayMs = event['delay'] is int ? event['delay'] as int : null;
    return SnackbarEvent(
      type: _parseType(event['type']),
      message: message,
      icon: icon,
      emoji: emoji,
      duration: duration,
      delayMs: delayMs,
    );
  }

  String _interpolate(String template, Map<String, String> args) {
    return args.entries.fold(
      template,
      (res, entry) => res.replaceAll('{${entry.key}}', entry.value),
    );
  }

  SnackbarType _parseType(String? type) {
    switch (type) {
      case 'error':
        return SnackbarType.error;
      case 'success':
        return SnackbarType.success;
      case 'info':
        return SnackbarType.info;
      case 'warning':
        return SnackbarType.warning;
      default:
        return SnackbarType.info;
    }
  }

  Duration _parseDuration(dynamic duration) {
    if (duration == null) {
      return const Duration(seconds: 3);
    }
    if (duration is int) {
      return Duration(seconds: duration);
    }
    if (duration is String) {
      switch (duration) {
        case 'short':
          return const Duration(seconds: 2);
        case 'long':
          return const Duration(seconds: 5);
        default:
          return Duration(seconds: int.tryParse(duration) ?? 3);
      }
    }
    return const Duration(seconds: 3);
  }
}
