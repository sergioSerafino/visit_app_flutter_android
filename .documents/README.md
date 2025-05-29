# .documents

Hier werden weiterführende Dokumentationen abgelegt, z.B.:
- Architekturübersichten
- technische Dokumentation
- externe Anforderungen
- Schnittstellenbeschreibungen
- Designentscheidungen

## Empfohlene Struktur
- `architecture.md` – Übersicht der Software-Architektur
- `api.md` – Schnittstellen und Datenmodelle
- `decisions/` – Architektur- und Designentscheidungen (z.B. als ADRs)
- `external_requirements.md` – externe Vorgaben, Normen, Standards

## Best Practices (GitHub Copilot & Copilot Chat)
- Nutze `/doc` für automatische Dokumentationskommentare.
- Verwende `@workspace` und Chatvariablen wie `#file`, `#class`, `#function` für gezielte Fragen und Dokumentationsaufgaben.
- Halte Dokumente versioniert und nachvollziehbar.
- Verlinke zentrale Dokumente in der Haupt-README.

## Hinweise
- Dokumente sollten versioniert und gepflegt werden.
- Für größere Themen Unterordner anlegen (z.B. `decisions/` für ADRs).
