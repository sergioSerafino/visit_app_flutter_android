# Teststrategie & Testdokumentation: Offline/Online-Handling mit Dio Interceptor

**Stand:** 26.06.2025

## Ziel

Diese Datei dokumentiert die Teststrategie, alle Testfälle und Testergebnisse für die neue Architektur zur robusten Offline/Online-Datenbehandlung in der Flutter-App. Im Fokus stehen der Retry-Interceptor (Dio), das FeedbackNotifier-System und die Integration mit Riverpod sowie dem globalen Snackbar-Manager.

## Architekturüberblick (Kurzfassung)
- **Dio Interceptor** prüft bei Netzwerkfehlern die Connectivity und stößt ggf. automatische Retries an.
- **FeedbackNotifier** abstrahiert Feedback-Events (z. B. für Snackbars/Dialoge) und ist per Provider injizierbar.
- **SnackbarFeedbackNotifier** leitet FeedbackEvents an den zentralen SnackbarManager weiter.
- **ApiClient** erhält Dio-Instanz und FeedbackNotifier per Dependency Injection.

## Teststrategie
- **Manuelle Tests**: Simulieren von Netzwerkfehlern, Offline-Modus, mehrfachen Retries, User-Flows mit und ohne Internet.
- **Automatisierte Widget-/Integrationstests**: Überprüfen, ob FeedbackEvents korrekt ausgelöst und Snackbars/Dialogs angezeigt werden.
- **Edge Cases**: Mehrfaches Retry, Wechsel zwischen Offline/Online, Race Conditions, Fehler bei Feedback-Auslieferung.

---

## Testfälle & Testschritte (laufend ergänzt)

### 1. Manueller Test: Kein Internet beim API-Call
- **Schritt:** Internetverbindung trennen (Flugmodus/WLAN aus).
- **Aktion:** API-Call im UI auslösen (z. B. Daten-Refresh).
- **Erwartung:**
    - Interceptor erkennt fehlende Verbindung.
    - FeedbackNotifier löst FeedbackEvent mit Typ `noConnection` aus.
    - Snackbar mit "Keine Internetverbindung" erscheint.
    - Kein Absturz, UI bleibt responsiv.
- **Ergebnis:** _(wird nach Testlauf ergänzt)_

### 2. Manueller Test: Internet kommt nach Retry zurück
- **Schritt:** Internetverbindung nach Fehler wiederherstellen.
- **Aktion:** API-Call erneut auslösen oder Retry abwarten.
- **Erwartung:**
    - Interceptor erkennt Connectivity-Änderung.
    - API-Call wird automatisch wiederholt.
    - Erfolgreiche Datenanzeige, Snackbar verschwindet.
- **Ergebnis:** _(wird nach Testlauf ergänzt)_

### 3. Edge Case: Mehrfaches schnelles Wechseln Online/Offline
- **Schritt:** Während eines laufenden API-Calls mehrfach zwischen Online/Offline wechseln.
- **Erwartung:**
    - Keine doppelten Snackbars.
    - Keine Race Conditions oder Abstürze.
- **Ergebnis:** _(wird nach Testlauf ergänzt)_

---

## Automatisierte Tests (geplant)
- Widget-Test: FeedbackNotifier löst bei simuliertem Netzwerkfehler ein FeedbackEvent aus.
- Integrationstest: Snackbar erscheint bei fehlender Verbindung, verschwindet nach erfolgreichem Retry.

---

## Beobachtungen & Bugs
- _(wird laufend ergänzt)_

---

## Offene Fragen / TODOs
- DialogManagerProvider für Dialog-Feedback?
- Alte Feedback-/Snackbar-Implementierungen entfernen?
- README/HowTo aktualisieren?

---

_Diese Datei wird fortlaufend gepflegt und ergänzt._
