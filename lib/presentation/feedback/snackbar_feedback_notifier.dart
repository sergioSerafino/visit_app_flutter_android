// lib/presentation/feedback/snackbar_feedback_notifier.dart
// Implementierung von FeedbackNotifier für das zentrale Snackbar-System

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; // Für debugPrint
import '../../core/messaging/feedback_notifier.dart';
import '../../core/messaging/snackbar_manager.dart';

class SnackbarFeedbackNotifier implements FeedbackNotifier {
  final Ref ref;
  SnackbarFeedbackNotifier(this.ref);

  @override
  void notify(FeedbackEvent event) {
    if (event.type == FeedbackEventType.snackbar) {
      ref
          .read(snackbarManagerProvider.notifier)
          .showByKey(event.message, args: event.data?.cast<String, String>());
    } else if (event.type == FeedbackEventType.dialog) {
      // Beispiel: Dialog-Trigger über einen Provider oder Callback
      // Hier könnte ein DialogEvent an einen DialogManagerProvider geschickt werden
      // ref.read(dialogManagerProvider.notifier).showDialog(event.message, event.data);
      // Oder Logging, je nach Bedarf
    } else if (event.type == FeedbackEventType.log) {
      // Logging, z.B. mit debugPrint oder einem Logger
      debugPrint('[FeedbackNotifier][LOG] ${event.message}');
    }
    // Optional: Weitere Event-Typen und deren Verarbeitung können hier ergänzt werden
  }
}

// Provider für die Dependency Injection (Riverpod)
final feedbackNotifierProvider = Provider<FeedbackNotifier>((ref) {
  // WidgetRef ist nur im Widget-Kontext verfügbar, daher hier ref als generischer ProviderRef nutzen
  return SnackbarFeedbackNotifier(ref);
});
