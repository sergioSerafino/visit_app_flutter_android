// lib/core/messaging/feedback_notifier.dart
// Abstraktion für Feedback-Events (SOLID, Clean Architecture)

/// Verschiedene Feedback-Event-Typen (Snackbar, Dialog, Logging etc.)
enum FeedbackEventType { snackbar, dialog, log }

/// Feedback-Event für UI- oder Logging-Feedback
class FeedbackEvent {
  final String message;
  final FeedbackEventType type;
  final Map<String, dynamic>? data;
  const FeedbackEvent(this.message,
      {this.type = FeedbackEventType.snackbar, this.data});
}

/// Abstraktion für Feedback-Events (z. B. Snackbar, Dialog, Logging)
abstract class FeedbackNotifier {
  void notify(FeedbackEvent event);
}
