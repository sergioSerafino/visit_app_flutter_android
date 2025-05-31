# Projektstart-Anleitung (Getting Started)

Diese Schritt-für-Schritt-Anleitung ist der zentrale Einstiegspunkt für alle Entwickler:innen und LLMs. Sie bündelt alle wichtigen Projektziele, Architekturprinzipien und HowTos für die Weiterentwicklung.

---

## 1. Voraussetzungen
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installiert
- Git installiert
- IDE wie VS Code, Android Studio oder IntelliJ empfohlen
- Für Mobile-Deployment: Xcode (iOS/macOS), Android Studio (Android)

---

## 2. Repository klonen
```powershell
git clone <REPO-URL>
cd <Projektordner>
```

---

## 3. Abhängigkeiten installieren
```powershell
flutter pub get
```

---

## 4. Projektstruktur & Produktziele verstehen
- **Zentrale Übersicht:** Siehe `.instructions/doku_matrix.md` (Matrix mit allen HowTos, Architektur- und Entscheidungsdokumenten)
- **Produktvision & Muss-Kriterien:** Siehe `.instructions/prd_white_label_podcast_app.md` (Leitlinie für alle neuen Features und Aufgaben)
- **Architektur & Layer:** `.instructions/architecture_clean_architecture.md` (Clean Architecture, Patterns, Prinzipien)
- **Projektstruktur & Best Practices:** `.instructions/project_structure_best_practices.md`
- **State-Management:** `.documents/state_management_riverpod_bloc.md`
- **Lessons Learned & Teststrategie:** Siehe `.documents/decisions/adr-003-teststrategie.md` für die konsolidierte Teststrategie, Lessons Learned und Doku-Integration aus der Migration.
- **Weitere HowTos:** Siehe Matrix und Querverweise in den einzelnen Dateien

---

## 5. Lokale Entwicklung starten
```powershell
flutter run
```

---

## 6. Eigene Features entwickeln
- Halte dich an Clean Architecture und die Muss-Kriterien aus dem PRD (siehe oben)
- Nutze Riverpod oder BLoC für State-Management
- Schreibe zu jedem neuen UseCase/Service einen Test
- Dokumentiere neue Features in den passenden Markdown-Dateien und ergänze die Doku-Matrix
- Beachte die Prinzipien-Matrix für alle wichtigen Regeln
- **Vor jeder Erweiterung:** Abgleich mit PRD, Architektur- und Struktur-Doku

---

## 7. Tests ausführen
```powershell
flutter test
```

---

## 8. Build & Deployment
- Siehe `.instructions/build.md` und `.instructions/ci_cd.md` für Build- und Deployment-Anleitungen
- Für Mobile-Deployment: Siehe die offiziellen Flutter-Guides für [Android](https://docs.flutter.dev/deployment/android) und [iOS](https://docs.flutter.dev/deployment/ios)
#- Für Web/Desktop: Siehe die auskommentierten Hinweise in CONTRIBUTING.md

---

## 9. Weitere Hilfen
- Nutze die Prompts in `.instructions/prompt.md` für Copilot Chat oder LLMs
- Bei Fragen: Siehe CONTRIBUTING.md und die Querverweise in den README-Dateien
- Für API und externe Anforderungen: `.documents/api.md` und `.documents/external_requirements.md`
- Für Architekturentscheidungen: `.documents/decisions/`
- **Doku-Matrix und PRD sind der Startpunkt für jede Weiterentwicklung!**

---

## 10. Legacy-/Migrationshinweise (aus storage_hold)

Dieses Projekt wurde aus einem Vorgängerprojekt migriert. Die ursprüngliche Schnellstart-Anleitung und Hinweise lauteten:

### Schnellstart (Altprojekt)
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

### Dokumentation (Altprojekt)
- **Zentrale Übersicht:** `.documents/doku_matrix.md` (Matrix mit allen HowTos, Architektur- und Entscheidungsdokumenten)
- **HowTos, Architektur, ADRs:** Siehe Querverweise in der Matrix und am Anfang jeder Datei

### Hinweise (Altprojekt)
- Bei Fragen zur Architektur, zu Features oder zur Codebasis immer zuerst die Doku-Matrix und Querverweise prüfen.
- Neue HowTos oder Doku bitte immer in `.documents/` anlegen und in der Matrix verlinken.

---

## Abschlussnotiz zur Migration (Mai 2025)

Diese Datei und das gesamte Projekt wurden im Rahmen einer strukturierten Migration aus dem Altprojekt `storage_hold` übernommen und nach Best Practice vereinheitlicht. Alle migrationsrelevanten Hinweise, HowTos und Entscheidungsdokumente sind zentral in der Doku-Matrix (`.instructions/doku_matrix.md`) und als "Legacy-/Migrationshinweise" am Ende der jeweiligen Dateien dokumentiert.

- Für Rückfragen zur Migration, zu Altprojekt-Workflows oder zur Doku-Struktur siehe die HowTos `howto_doku_migration.md` und `howto_doku_instruction_merge.md`.
- Die Review- und Dubletten-Checkliste sowie die Migrationsmatrix sind in `.instructions/` abgelegt und werden laufend gepflegt.
- Die Migration ist mit diesem Stand abgeschlossen und alle Inhalte sind konsolidiert, versioniert und LLM-freundlich dokumentiert.

---

## Letzter Review-Stand (30.05.2025)

- Die Migration und Vereinheitlichung der Dokumentation ist abgeschlossen.
- Alle migrationsrelevanten Inhalte aus dem Altprojekt sind als "Legacy-/Migrationshinweise" dokumentiert.
- Die Doku-Matrix, Review-Checkliste und Migrationsmatrix sind aktuell.
- Die HowTos und Entscheidungsdokumente sind zentral und LLM-freundlich abgelegt.
- Für weitere Migrationen siehe die HowTos und Abschlussnotiz.

---

## 8. Migrationsprotokoll (Stand: 31.05.2025)

**Migration aus storage_hold abgeschlossen:**
- Vollständige Übernahme und Refaktorierung aller zentralen Layer (domain, data, application, core, config, presentation) gemäß Clean Architecture und LLM-Prinzipien.
- Alle Models, Enums, Provider, Controller, Listener und Widgets sind migrationskonform, dokumentiert und Dubletten-bereinigt.
- Linting, Build und Review mehrfach erfolgreich durchgeführt, keine Blocking-Fehler im Zielprojekt.
- Migrationsmatrix und Review-Checkliste sind aktuell und dokumentieren alle Schritte.
- Die Quell- und Migrationsordner (`storage_hold`, `_migration_src`) enthalten nur noch Alt- und Vergleichsstände.
- Zentrale Abschlussprüfung am 31.05.2025: Zielprojekt ist robust, nachvollziehbar und zukunftssicher.

**Nächste Schritte:**
- Alt- und Migrationsordner können archiviert oder entfernt werden.
- Weitere Entwicklung bitte ausschließlich im Zielprojekt nach den dokumentierten Prinzipien.

---

Viel Erfolg beim Projektstart! Bei Unsicherheiten: Im Team oder in der Dokumentation nachfragen.
