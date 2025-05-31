# Flutter Template Projekt

Dieses Projekt ist ein modernes, best-practice-orientiertes Flutter-Template mit klarer Dokumentationsstruktur, Clean Architecture, State-Management (Riverpod/BLoC), automatisierten Tests und LLM/Automatisierungs-Support.

## Hinweise zur Projektstruktur
- Alle relevanten Best-Practices, Prinzipien und Vorgehensweisen wurden aus dem temporären Ordner `anderes_projekt` extrahiert und in die zentrale Dokumentation übernommen.
- Der Ordner `anderes_projekt` kann nach Abschluss der Template-Erstellung gelöscht werden und ist nicht Teil des eigentlichen Templates.

## Einstieg
- Lies die [GETTING_STARTED.md](GETTING_STARTED.md) für eine Schritt-für-Schritt-Anleitung.
- Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Mitwirkende.
- Siehe `.documents/` und `.instructions/` für alle Architektur-, Doku- und HowTo-Themen.

## Übersichtlichkeit & Struktur – Best Practices

- Klare, konsistente Ordner- und Dateistruktur (z. B. domain, data, presentation, application, config, core)
- Sprechende, einheitliche Namen für Dateien, Klassen, Methoden und Variablen
- Kurze, prägnante Funktionen und Klassen (keine "God-Classes")
- Einrückung, Leerzeilen und Klammern nach Style Guide (siehe analysis_options.yaml)
- Kommentare nur dort, wo der Code nicht sprechend selbsterklärend ist, mit Praxisbezug und ggf. Quellenangabe
- Zentrale Ablage von Architektur, Prozessen und HowTos in `.documents/` und `.instructions/`
- Trennung von UI und Logik (State Management, keine Business-Logik in Widgets)
- Widget-Aufteilung: Komplexe UI in eigene Widgets/Funktionen auslagern
- Nutzung von const-Widgets, wo möglich
- Zentrale Styles und Theme-Konfiguration für konsistentes Aussehen
- Teststruktur: Trennung von unit, widget und integration tests in eigenen Ordnern
- Plattformspezifische Ordner und Konfigurationsdateien sauber halten
- Build-Skripte und CI/CD klar strukturieren und dokumentieren
- Feature Flags/Environment Configs für plattformspezifische Einstellungen
- Schritt-für-Schritt-Dokumentation für alle Deployment-Zielsysteme

## Code Style & Formatierung

- Nach jeder Widget- und Klassen-Definition folgt grundsätzlich eine Leerzeile.
- Diese Konvention dient der Übersichtlichkeit und Lesbarkeit und ist auch bei automatischer Formatierung (z. B. mit `dart format`) zu beachten.
- Weitere Style-Konventionen siehe analysis_options.yaml.

**Quellen & Community-Standards:**
- [Flutter/Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Clean Architecture (Reso Coder)](https://resocoder.com/)
- [Very Good Ventures Best Practices](https://verygood.ventures/)
- [Flutter.dev Dokumentation](https://docs.flutter.dev/)

Viel Erfolg beim Projektstart und der Weiterentwicklung!

- Siehe `.documents/howto_snackbar.md` für die Nutzung und Erweiterung des SnackBar-Systems.

## Automatisierte Doku-Pflege

- Änderungen an Code, Architektur oder Tests müssen immer in der README.md und Doku-Matrix dokumentiert werden.
- Pre-Commit- und CI-Checks stellen sicher, dass die Doku aktuell bleibt.
- TODOs im Code werden regelmäßig in die Doku übernommen.
- Siehe `.documents/doku_matrix.md` für die zentrale Übersicht.

---

## Automatisierte Doku-Pflege – Bedienungsanweisung

Damit die Dokumentation immer aktuell bleibt, ist ein automatischer Pre-Commit-Hook eingerichtet:

1. **Was macht der Hook?**
   - Prüft, ob bei Änderungen an Code (z. B. in `lib/`, `test/`, `application/`, `core/`, `presentation/`) auch die `README.md` aktualisiert wurde.
   - Falls nicht, wird der Commit abgebrochen und ein Hinweis ausgegeben.

2. **Wie aktiviere ich den Hook?**
   - Stelle sicher, dass PowerShell als Standard-Shell verwendet wird (Windows-Standard).
   - Die Datei `.git/hooks/pre-commit.ps1` ist bereits im Projekt enthalten.
   - Ggf. muss die Ausführung von Skripten erlaubt werden:
     - Öffne PowerShell als Administrator und führe aus:
       ```powershell
       Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned
       ```
     - (Nur einmalig nötig, falls noch nicht geschehen.)

3. **Wie funktioniert der Workflow?**
   - Bei jedem `git commit` prüft der Hook automatisch die Bedingungen.
   - Falls die Doku nicht aktualisiert wurde, erscheint eine gelbe Warnung und der Commit wird abgebrochen.
   - Aktualisiere dann die `README.md` und/oder `.documents/doku_matrix.md` und führe den Commit erneut aus.

4. **Wie kann ich den Hook anpassen oder deaktivieren?**
   - Passe das Skript in `.git/hooks/pre-commit.ps1` nach Bedarf an.
   - Um den Hook temporär zu deaktivieren, benenne die Datei um oder entferne sie.

**Hinweis:**
- Die automatisierte Doku-Pflege ist ein wichtiger Bestandteil der Projektqualität und hilft, die Übersicht und Nachvollziehbarkeit zu sichern.
- Siehe `.documents/doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien.

---

## Automatischer TODO-Scan aus dem Code

Um alle offenen TODOs im Code zentral zu dokumentieren, steht das Skript `scripts/scan_todos.ps1` zur Verfügung:

1. **Was macht das Skript?**
   - Durchsucht alle relevanten Code-Ordner (`lib/`, `test/`, `application/`, `core/`, `presentation/`) nach `// TODO:`-Kommentaren.
   - Schreibt alle gefundenen TODOs mit Pfad und Zeilennummer in die Datei `TODOs_aus_Code.md` im Projektverzeichnis.

2. **Wie führe ich das Skript aus?**
   - Stelle sicher, dass PowerShell-Skripte ausgeführt werden dürfen (siehe oben).
   - Im Projektverzeichnis ausführen:
     ```powershell
     .\scripts\scan_todos.ps1
     ```
   - Die Datei `TODOs_aus_Code.md` wird automatisch erstellt oder aktualisiert.

3. **Empfohlener Workflow:**
   - Vor jedem Release oder Sprint-Ende das Skript ausführen, um alle offenen TODOs zu konsolidieren.
   - Die Datei `TODOs_aus_Code.md` regelmäßig prüfen und offene Punkte priorisieren.
   - Optional: Die TODO-Liste in den Status-Report oder die Doku-Matrix übernehmen.

**Hinweis:**
- Der automatisierte TODO-Scan hilft, technische Schulden und offene Aufgaben im Blick zu behalten und transparent zu dokumentieren.
- Siehe auch die Bedienungsanweisung zur automatisierten Doku-Pflege oben.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Dieses Template-Projekt wurde aus dem Altprojekt `storage_hold` migriert.

- Ursprünglicher Projektname: **storage_hold**
- Historischer Hinweis: Grundständiges Testprojekt für die Flutter App mit dem Mediendatenteil remote (API) und lokal (Mock).
- Siehe auch: `.documents/doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).

---

## Automatisierte Integration des TODO-Scans in den Pre-Commit-Hook

Um sicherzustellen, dass alle TODOs vor jedem Commit automatisch erfasst werden, kann das Skript `scripts/scan_todos.ps1` direkt im Pre-Commit-Hook aufgerufen werden:

**So funktioniert es:**
- Der Pre-Commit-Hook ruft vor jedem Commit automatisch das Skript auf.
- Die Datei `TODOs_aus_Code.md` wird immer aktuell gehalten.
- Entwickler:innen werden so an offene TODOs erinnert und können diese gezielt pflegen.

**Integration in `.git/hooks/pre-commit.ps1`:**
Füge am Anfang des Pre-Commit-Hooks folgende Zeile ein:

```powershell
# Automatischer TODO-Scan vor jedem Commit
& scripts/scan_todos.ps1
```

**Empfohlener Workflow:**
- Vor jedem Commit werden alle TODOs im Code automatisch gescannt und dokumentiert.
- Prüfe die Datei `TODOs_aus_Code.md` regelmäßig und übertrage wichtige Punkte in die Status-Doku oder Doku-Matrix.

---

## Abschluss-Review & Refactoring-Checkliste (31.05.2025)

**1. Letztes Refactoring vor Entfernung des Quell-Projekts:**
- [ ] Unbenutzte Imports entfernen (siehe Lint-Warnungen)
- [ ] Lint-Warnungen und Hinweise (z. B. Redundanzen, Annotationen, Super-Parameter) beheben
- [ ] Lesbarkeit und Struktur nach SOLID und Clean Architecture prüfen (keine God-Classes, klare Verantwortlichkeiten)
- [ ] Testabdeckung für alle kritischen UseCases, Services und Provider sicherstellen
- [ ] Automatisierte Tests und Linting vor jedem Merge/Release ausführen

**2. Abschließender Review:**
- [ ] Review-Checkliste aus Status-Report und Doku-Matrix durchgehen
- [ ] Alle Muss-Kriterien aus PRD/MVP und Architektur-Doku erfüllt
- [ ] Alle Kern-User-Flows funktionieren stabil (Code & UI geprüft)
- [ ] Fallback- und Placeholder-Logik überall abgedeckt und getestet
- [ ] UI/UX: Keine groben Brüche, alle wichtigen Elemente zugänglich
- [ ] Architektur: Clean, testbar, keine kritischen TODOs
- [ ] Testabdeckung: Alle kritischen Services/Provider mit Unit-/Integrationstests
- [ ] Offene Bugs/TODOs dokumentiert und priorisiert

**3. Quell-Projekt entfernen:**
- [ ] Sicherstellen, dass alle relevanten Inhalte aus `storage_hold` übernommen und dokumentiert sind
- [ ] Ordner `storage_hold` und ggf. `_migration_src` entfernen
- [ ] Schritt in der Migrationsmatrix und im Changelog dokumentieren

**Hinweis:**
- Nach Abschluss dieser Checkliste ist das Zielprojekt vollständig eigenständig, wartbar und zukunftssicher.
- Die Clean Architecture, SOLID-Prinzipien und Best Practices sind dokumentiert und umgesetzt.
- Die Entfernung des Quell-Projekts ist damit risikolos möglich.

---
