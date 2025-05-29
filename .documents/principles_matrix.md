# Prinzipien- und Best-Practice-Matrix (Stand: 29.05.2025)

| Bereich              | Prinzip/Best Practice                                                                 | Quelle/Verweis                                   |
|----------------------|-------------------------------------------------------------------------------------|--------------------------------------------------|
| Architektur          | Clean Architecture (Domain, Data, Application, Presentation)                         | architecture_clean_architecture.md, ADR-002      |
| State Management     | Riverpod für reaktives, BLoC für komplexe Logik, keine Logik in Widgets              | state_management_riverpod_bloc.md, bloc_best_practices_2024.md |
| Fehlerbehandlung     | sealed classes, Either/Option, eigene Result-Typen                                   | architecture_clean_architecture.md               |
| Projektstruktur      | Feature-basierte Modularität, README in jedem Hauptordner                            | project_structure_best_practices.md              |
| Dependency Injection | get_it, injectable, Async-Init                                                       | architecture_clean_architecture.md               |
| Testing              | TDD, Tests für UseCases/Services, automatisierte Tests in CI                         | architecture_clean_architecture.md, ci_cd.md     |
| Automatisierung/LLM  | `.instructions` für HowTos, Prompts, LLM-Guidelines, Querverweise in README          | instructions_llm.md, prompt.md, .instructions/   |
| Dokumentation        | `.documents` für Architektur, API, ADRs, externe Anforderungen, versioniert & gepflegt| .documents/README.md, api.md, external_requirements.md |
| Build/CI             | Automatisierte Tests, Linting, sichere Secrets, Build-Fehler mit Copilot Chat lösen  | ci_cd.md, build.md                               |

## Hinweise
- Alle Prinzipien und Empfehlungen sind konsistent und ergänzen sich gegenseitig.
- Querverweise in README-Dateien erleichtern die Navigation.
- Für neue Features/Änderungen: immer an diese Matrix und die verlinkten Dokumente halten.
- LLMs und Entwickler:innen können diese Matrix als zentrale Orientierung nutzen.
