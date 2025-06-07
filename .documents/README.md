# .documents

Hier werden weiterführende Dokumentationen abgelegt, z.B.:
- Architekturübersichten
- technische Dokumentation
- externe Anforderungen
- Schnittstellenbeschreibungen
- Designentscheidungen
- Prinzipien- und Best-Practice-Matrix (siehe principles_matrix.md)

## Empfohlene Struktur
- `architecture.md` – Übersicht der Software-Architektur
- `architecture_clean_architecture.md` – Clean Architecture & TDD
- `bloc_best_practices_2024.md` – Modernes BLoC-Pattern
- `project_structure_best_practices.md` – Projektstruktur & Prinzipien
- `state_management_riverpod_bloc.md` – State-Management-Empfehlungen
- `api.md` – Schnittstellen und Datenmodelle
- `decisions/` – Architektur- und Designentscheidungen (z.B. als ADRs)
- `external_requirements.md` – externe Vorgaben, Normen, Standards
- `principles_matrix.md` – Übersicht aller Prinzipien & Empfehlungen
- `prd_white_label_podcast_app.md` – Produkt-Requirements-Dokument

## Best Practices (GitHub Copilot & Copilot Chat)
- Nutze `/doc` für automatische Dokumentationskommentare.
- Verwende `@workspace` und Chatvariablen wie `#file`, `#class`, `#function` für gezielte Fragen und Dokumentationsaufgaben.
- Halte Dokumente versioniert und nachvollziehbar.
- Verlinke zentrale Dokumente in der Haupt-README.

## Hinweise
- Dokumente sollten versioniert und gepflegt werden.
- Für größere Themen Unterordner anlegen (z.B. `decisions/` für ADRs).
- Die Prinzipien-Matrix (principles_matrix.md) bietet eine zentrale Übersicht und Querverweise.
- Historisch oder für spätere Nachvollziehbarkeit relevante Inhalte werden im Archiv-Ordner [docs/legacy/](../docs/legacy/) gesichert. Siehe Best-Practice-Abschnitt in .instructions/project_structure_best_practices.md.

## Doku-Pflege & Querverweise (Stand: 07.06.2025)
- Nach jedem neuen Feature, Refactoring oder Test-Update sind alle relevanten Doku-Dateien, die Doku-Matrix (`.instructions/doku_matrix.md`) und die Lessons-Learned-Abschnitte zu aktualisieren.
- Die Doku-Matrix ist der zentrale Einstiegspunkt für HowTos, Best Practices und Lessons Learned.
- Querverweise auf zentrale Architektur-, Test- und Best-Practice-Dokumente (z.B. `docs/audio_architektur_2025.md`, `docs/audio_player_best_practices_2025.md`, `decisions/adr-003-teststrategie.md`) sind aktuell zu halten.
- Lessons Learned und Teststrategie werden laufend dokumentiert und gepflegt.
- Siehe auch die Hinweise in `.instructions/README.md` und `.instructions/project_structure_best_practices.md`.

Siehe auch [docs/audio_architektur_2025.md](../docs/audio_architektur_2025.md) für die aktuelle Architekturübersicht und Best Practices zum Audio-Streaming-Stack (BLoC, Backend, AudioHandler, Testbarkeit, Provider-Pattern).
