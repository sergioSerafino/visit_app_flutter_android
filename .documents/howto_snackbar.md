# HowTo: SnackBar-System im Template

Dieses Template enthält ein flexibles, konfigurierbares SnackBar-System auf Basis von Riverpod und zentraler YAML-Konfiguration.

## 1. Funktionsweise
- SnackBar-Events werden über den `SnackbarManager` ausgelöst (Provider-basiert).
- Die Konfiguration erfolgt in `lib/core/messaging/snackbar_config.yaml`.
- Die Anzeige übernimmt das Widget `GlobalSnackbarListener` (in `presentation/widgets/`).

## 2. Integration in die App
- In `main.dart` wird die App mit `GlobalSnackbarListener` umschlossen.
- Beispiel:
  ```dart
  void main() {
    runApp(const ProviderScope(child: MyApp()));
  }
  // ...
  Widget build(BuildContext context) {
    return GlobalSnackbarListener(
      child: MaterialApp(
        scaffoldMessengerKey: GlobalSnackbarListener.scaffoldMessengerKey,
        // ...
      ),
    );
  }
  ```

## 3. SnackBar-Event auslösen
- Überall im Code (z. B. Button, Provider, UseCase):
  ```dart
  ref.read(snackbarManagerProvider.notifier).showByKey('welcome_back');
  ```
- Argumente können als Map übergeben werden, z. B. für Platzhalter in der Message.

## 4. Eigene Events/Messages hinzufügen
- In `snackbar_config.yaml` neue Events ergänzen:
  ```yaml
  my_event:
    duration: short
    icon: "✅"
    message: "Aktion erfolgreich!"
    type: success
  ```
- Optional: In `snackbar_messages.dart` zentrale Texte pflegen.

## 5. Konfigurierbarkeit
- Emojis, Icons, Farben, Dauer und Verzögerung sind pro Event konfigurierbar.
- Die Factory unterstützt flexible Typen und Platzhalter.

## 6. Fehlerbehandlung & Fallback
- Bei fehlender/fehlerhafter Konfiguration wird ein Fallback angezeigt.
- Unbekannte Keys führen zu einer generischen Info-Snackbar.

## 7. Testbarkeit
- Die Factory und der Manager sind so gestaltet, dass sie leicht getestet werden können (z. B. Unit-Tests für Event-Erzeugung und Fehlerfälle).

---

Weitere Details und Beispiele siehe die Dateien in `lib/core/messaging/` und die Integration in `main.dart`.
