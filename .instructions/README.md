# .instructions

In diesem Ordner werden alle projektspezifischen Anleitungen, HowTos, LLM-Prompts und Build-/Deployment-Informationen gesammelt.

## Empfohlene Struktur
- `build.md` – Hinweise zum Bauen und Deployen des Projekts
- `setup.md` – Projekt-Setup und lokale Entwicklungsumgebung
- `ci_cd.md` – Hinweise zu CI/CD, Automatisierung und Pipelines
- `prompt.md` – Beispielprompts für LLMs und Automatisierung
- `instructions_llm.md` – LLM-/Automatisierungsanweisungen
- `merge_decisions_and_field_sources.md` – Entscheidungsdokumentation für MergeService

## Querverweise & Ergänzungen
- Siehe `.documents/principles_matrix.md` für eine zentrale Übersicht aller Prinzipien und Empfehlungen.
- Für Architektur und State-Management siehe `.documents/architecture_clean_architecture.md` und `.documents/state_management_riverpod_bloc.md`.
- Für Produktanforderungen siehe `.documents/prd_white_label_podcast_app.md`.

## Best Practices (GitHub Copilot & Copilot Chat)
- Nutze `/explain`, `/fix`, `/tests`, `/doc` für schnelle Analysen, Erklärungen und Testgenerierung.
- Verwende `@workspace` für projektweiten Kontext und Analysen.
- Halte Anleitungen aktuell und klar strukturiert.
- Verlinke wichtige HowTos in der Haupt-README.

## Hinweise
- Jede Anleitung sollte klar, prägnant und aktuell gehalten werden.
- Für wiederkehrende Aufgaben (z.B. Release, Migration) eigene HowTos anlegen.
- Verweise in der Haupt-README oder CONTRIBUTING.md auf diesen Ordner, damit auch andere Entwickler und Tools ihn finden.

## Kommentar- und Dokumentationsstil

- Alle Kommentare im Code (und in neuen Dateien) sollen in klarer, verständlicher Sprache verfasst werden.
- Praxisbezug: Kommentare sollen – wie im Template – auf Best Practices, Quellen (z. B. Reso Coder) und konkrete Anwendungsszenarien eingehen.
- Stil: Prägnant, hilfreich, mit Verweis auf relevante Doku-Dateien (z. B. `.documents/architecture_clean_architecture.md`).
- Beispiel siehe Testvorlage in `test/widget_test.dart`.

## Code Style & Formatierung

- Nach jedem return-Statement im Widget-Baum folgt eine Leerzeile (siehe Beispiel in lib/main.dart).
- Kommentare im Code sollen Stil, Praxisbezug und Sprache des Templates aufgreifen (siehe Abschnitt "Kommentar- und Dokumentationsstil").
- Weitere Style-Konventionen siehe analysis_options.yaml.
