# GETTING_STARTED.md

## Einstieg in das Projekt

Willkommen! Dieses Projekt nutzt eine moderne Clean Architecture mit Riverpod, BLoC und Hive. Die gesamte technische und fachliche Dokumentation findest du im Verzeichnis `.documents/` im Projektroot.

### Schnellstart
1. Repository klonen
2. Abhängigkeiten installieren:
   ```powershell
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. App starten:
   ```powershell
   flutter run
   ```

### Dokumentation
- **Zentrale Übersicht:** `.documents/doku_matrix.md` (Matrix mit allen HowTos, Architektur- und Entscheidungsdokumenten)
- **HowTos, Architektur, ADRs:** Siehe Querverweise in der Matrix und am Anfang jeder Datei

### Hinweise
- Bei Fragen zur Architektur, zu Features oder zur Codebasis immer zuerst die Doku-Matrix und Querverweise prüfen.
- Neue HowTos oder Doku bitte immer in `.documents/` anlegen und in der Matrix verlinken.

Viel Erfolg beim Einstieg!
