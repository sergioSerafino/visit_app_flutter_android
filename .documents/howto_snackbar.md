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

## 8. Branding-Farben & Snackbar-Visibility

- Die Sichtbarkeit und Lesbarkeit von Snackbars hängt direkt von den im Branding gesetzten Farben ab, insbesondere von `secondaryColorHex`.
- Fehlt dieser Wert oder ist er ungültig (z. B. leerer String), kann es passieren, dass Snackbars unsichtbar oder schwer lesbar sind.
- **Best Practice:** Für jeden Mandanten/Host muss in `host_model.json` ein valider Wert für `secondaryColorHex` gesetzt sein (z. B. `#EEEEEE` für helles Grau).
- Für automatisierte Qualitätssicherung gibt es das Skript [`scripts/fix_branding_colors.dart`](../scripts/README_fix_branding_colors.md), das alle Brandings prüft und fehlende/ungültige Werte automatisch setzt.
- Das Skript kann nach jedem Branding-Update oder als Pre-Commit-Hook ausgeführt werden.

**Beispiel:**
```json
"branding": {
  "primaryColorHex": "#673AB7",
  "secondaryColorHex": "#EEEEEE",
  ...
}
```

## Snackbar-Textfarbe: Automatische Lesbarkeit mit Schwellwert

Die Snackbar-Implementierung verwendet einen dynamischen Schwellwert für die Textfarbe, um maximale Lesbarkeit zu gewährleisten – unabhängig vom Branding oder der gewählten Snackbar-Farbe.

- Die Textfarbe wird abhängig von der Luminanz des Snackbar-Hintergrunds gesetzt:
  - Ist der Hintergrund sehr hell (Luminanz > 0.6), wird **schwarze** Schrift verwendet.
  - In allen anderen Fällen wird **weiße** Schrift bevorzugt.
- Die Luminanz wird mit `Color.computeLuminance()` berechnet.
- Der Schwellwert (0.6) ist bewusst etwas höher als der Flutter-Standard (0.5), um auch bei mittleren Farben Weiß zu bevorzugen und so die Lesbarkeit zu maximieren.
- Die Logik ist in der Methode `_textColorForSnackbar` in `lib/presentation/widgets/global_snackbar.dart` dokumentiert und kann bei Bedarf angepasst werden.

**Beispiel:**
```dart
Color _textColorForSnackbar(SnackbarType type, Branding branding) {
  final bg = _colorForType(type, branding);
  final double luminance = bg.computeLuminance();
  if (luminance > 0.6) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}
```

Damit ist sichergestellt, dass Snackbar-Messages immer sichtbar und optimal lesbar sind – unabhängig vom Tenant-Branding.

---

Weitere Details und Beispiele siehe die Dateien in `lib/core/messaging/` und die Integration in `main.dart`.
