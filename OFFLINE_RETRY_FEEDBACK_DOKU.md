# Dokumentation: Offline/Online-Handling, Retry-Interceptor & Feedback-System

## Zielsetzung
Diese Dokumentation beschreibt die Architektur, Implementierung und Teststrategie für das moderne Offline/Online-Handling in der Flutter-App. Im Fokus stehen ein SOLID-konformer Dio-Interceptor mit automatischem Retry, ein abstrahiertes Feedback-System (Snackbar/Dialog) und deren Integration mit Riverpod, Caching und der globalen Snackbar.

---

## 1. Architekturüberblick
- **Dio Interceptor**: Erkennt Verbindungsprobleme, triggert Retry und meldet Feedback-Events an eine Abstraktion (`FeedbackNotifier`).
- **FeedbackNotifier**: Abstrakte Schnittstelle für Feedback-Events (Snackbar/Dialog), lose gekoppelt, testbar.
- **SnackbarFeedbackNotifier**: Konkrete Implementierung für Snackbars, im Presentation-Layer, via Provider injizierbar.
- **ApiClient**: Erhält Dio und FeedbackNotifier per Dependency Injection, Provider gibt korrekt injizierte Instanz zurück.
- **Provider-Architektur**: Riverpod-Provider für ApiClient, FeedbackNotifier etc.
- **Teststrategie**: Umfasst manuelle und automatisierte Widget-/Integrationstests, alle Testfälle werden dokumentiert.

---

## 2. Implementierungsschritte
- FeedbackNotifier-Abstraktion und FeedbackEvent ausgelagert (`lib/core/messaging/feedback_notifier.dart`).
- SnackbarFeedbackNotifier im Presentation-Layer implementiert (`lib/presentation/feedback/snackbar_feedback_notifier.dart`).
- RetryOnConnectionChangeInterceptor refaktoriert: meldet nur noch FeedbackEvents, keine UI-Logik.
- ApiClient und Provider-Architektur auf Dependency Injection umgestellt.
- Test- und Beispielcode auf neue Architektur angepasst.
- Teststrategie und erste Testfälle in Markdown-Dokumentation angelegt.

---

## 3. Teststrategie & Testfälle
Alle Testfälle, Testschritte und Beobachtungen werden in `TESTSTRATEGIE_OFFLINE_RETRY.md` dokumentiert.

### 3.1 Manuelle Tests
- **Kein Internet**: Feedback (Snackbar) erscheint, Retry wird ausgelöst.
- **Internet wieder da**: Request wird erneut gesendet, Feedback verschwindet.
- **Edge Cases**: Mehrfache Retries, schnelles Wechseln der Verbindung, etc.

### 3.2 Automatisierte Tests (geplant)
- Widget-/Integrationstests für FeedbackNotifier, Interceptor und Snackbar-Feedback.
- Mocking von Connectivity, Dio und FeedbackNotifier.
- Überprüfung, ob FeedbackEvents korrekt ausgelöst und verarbeitet werden.

---

## 4. Beobachtungen & Lessons Learned
- Architektur ist jetzt SOLID-konform, lose gekoppelt und testbar.
- Feedback-System kann einfach erweitert werden (z. B. für Dialoge).
- Teststrategie wird laufend ergänzt und angepasst.

---

## 5. ToDos & Nächste Schritte
- Automatisierte Widget-/Integrationstests umsetzen.
- Testfälle und Ergebnisse laufend ergänzen.
- Optional: DialogManagerProvider für Dialog-Feedback implementieren.
- Alte Feedback-/Snackbar-Implementierungen entfernen.
- README/HowTo und Querverweise aktualisieren.

---

## 6. Quellen & Referenzen
- Reso Coder: Dio Interceptor Retry Tutorial
- Eigene HowTos und Architektur-Dokumente (`.instructions/howto_dio_interceptor_offline_retry.md`,`.instructions\howto_placeholder_fallback.md`)
- Teststrategie: `TESTSTRATEGIE_OFFLINE_RETRY.md`

---

*Letzte Aktualisierung: 26.06.2025*
