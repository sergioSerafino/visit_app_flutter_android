# CONTRIBUTING.md

## Dokumentationsstruktur

Alle Architektur-, HowTo- und Entscheidungsdokumente befinden sich im Verzeichnis `.documents/` im Projektroot. Die Datei `doku_matrix.md` bietet eine zentrale Übersicht und Querverweise zu allen relevanten Doku-Dateien.

### Einstiegspunkt
- **Doku-Matrix:** `.documents/doku_matrix.md` (zentrale Übersicht, Querverweise)
- **HowTos, Architektur, ADRs:** Siehe Matrix und Querverweise in den einzelnen Dateien

### Neue Dokumente anlegen
1. Neue HowTos, Architektur- oder Entscheidungsdokumente immer im Verzeichnis `.documents/` (bzw. `.documents/decisions/` für ADRs) ablegen.
2. Den neuen Eintrag in der `doku_matrix.md` ergänzen.
3. Am Anfang der Datei einen Querverweis auf die Matrix und ggf. verwandte Themen ergänzen (siehe Beispiele in bestehenden Dateien).

### Namenskonventionen
- Bei gleichnamigen Dateien bitte mit Suffix wie `-2` oder ähnlichem kennzeichnen, um Überschreibungen zu vermeiden.

## Code-Conventions und Review
- Siehe `.documents/project_structure_best_practices.md` und `.documents/architecture_clean_architecture.md` für Architektur- und Coding-Guidelines.
- Review-Checkliste und offene Punkte: `.documents/status_report.md`

## Fragen
- Bei Unklarheiten bitte zuerst die Doku-Matrix und Querverweise prüfen.
- Für neue Themen oder größere Änderungen bitte einen kurzen Hinweis in der Matrix und im Status-Report ergänzen.
