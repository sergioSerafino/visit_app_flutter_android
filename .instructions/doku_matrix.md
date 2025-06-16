# Doku-Matrix / Übersichtstabelle

Diese Matrix bietet eine zentrale Übersicht aller wichtigen Doku-, HowTo- und Entscheidungsdateien im Projekt. Sie erleichtert die Navigation, Pflege und Erweiterung der Dokumentation – für Entwickler:innen und LLMs.

| Kategorie         | Datei/Link                                   | Inhalt/Schwerpunkt                                  | Querverweise                       |
|------------------|----------------------------------------------|-----------------------------------------------------|-------------------------------------|
| Architektur      | architecture_clean_architecture.md            | Clean Architecture, Patterns, Prinzipien             | project_structure_best_practices.md |
| Projektstruktur  | project_structure_best_practices.md           | Layer, Ordner, Best Practices                        | architecture_clean_architecture.md  |
| BLoC/State Mgmt  | bloc_tutorial_24.md                          | BLoC-Pattern, Dart 3, Riverpod                       |                                     |
| TDD/Clean Arch   | clean_architecture_tdd_differences_2024.md    | Unterschiede, TDD, Clean Arch                        |                                     |
| Status/Review    | status_report.md                              | Status, Review-Checkliste, offene Punkte             | prd_white_label_podcast_app.md      |
| PRD/MVP          | prd_white_label_podcast_app.md                | Produkt-Requirements, MVP, Feature-Liste             | status_report.md                    |
| HowTo: Merge     | howto_merge_caching.md                        | MergeService, Caching, Offline-Strategie             | adr-001-merge-strategy.md           |
| HowTo: FeatureFlags | howto_feature_flags.md                     | FeatureFlags, Provider, Caching, Tests               |                                     |
| HowTo: UI/Design | howto_ui_design.md                            | UI/UX, Design-Todos, Accessibility                   |                                     |
| HowTo: CollectionId | howto_collectionid_refactoring.md           | CollectionId-Provider, Refactoring                   | howto_collection_registry.md         |
| HowTo: Registry  | howto_collection_registry.md                  | CollectionRegistry, Validierung                      | howto_collectionid_refactoring.md    |
| HowTo: Dev-Flag  | howto_dev_env_flag.md                         | DEV/ENV-Flag, Fehlerausgabe                          |                                     |
| HowTo: Naming    | howto_naming_conventions.md                    | Namenskonventionen                                   |                                     |
| HowTo: Paging    | howto_paging_caching.md                        | Paging, Caching, Provider                            |                                     |
| HowTo: RSS/Merge | howto_rss_redirects_and_merge_learnings.md     | RSS-Feed-Handling, Redirects, Merge-Learnings        | howto_merge_caching.md              |
| Merge-Entscheid. | howto_merge_decisions_and_field_sources.md     | Merge-Entscheidungen, Feldherkunft                   | adr-001-merge-strategy.md           |
| ADR: Merge       | decisions/adr-001-merge-strategy.md            | Merge-Architektur, Strategie                         | howto_merge_caching.md              |
| ADR: Cast        | decisions/adr-002-cast-architektur.md          | AirPlay/Chromecast-Architektur                       |                                     |
| ADR: Clean Architecture | decisions/adr-002-clean-architecture.md | Clean Architecture, Layer, State-Management, DI | architecture_clean_architecture.md |
| Build/Deployment | build.md | Build- und Deployment-Anleitung für das Flutter-Projekt | ci_cd.md |
| CI/CD            | ci_cd.md | Hinweise zu CI/CD-Prozessen | build.md |
| Migration        | project_migrieren_vorbereitung.md | Vorbereitungsschritte für die Projektmigration | howto_doku_migration.md |
| Meta/HowTo       | instructions.md | Zentrale Übersicht und Anleitungen für das Arbeiten mit .instructions | instructions_llm.md |
| Meta/LLM         | instructions_llm.md | Hinweise zur LLM-optimierten Nutzung der Anleitungen | instructions.md |
| Prompting        | prompt.md | Prompt-Vorlagen und Beispiele für Copilot/LLM | |
| Setup            | setup.md | Setup-Anleitung für das Projekt | GETTING_STARTED.md |
| Update (31.05.2025) | architecture_clean_architecture.md, project_structure_best_practices.md | Architektur- und Projektstruktur-Update für die Weiterentwicklung, verbindliche Layer-Trennung, Doku-Pflege | alle |
| Teststrategie & Lessons Learned | decisions/adr-003-teststrategie.md | Teststrategie, Lessons Learned, Doku-Integration aus Migration | status_report.md, howto_merge_caching.md |

**Hinweis:**
- Diese Matrix ist zentraler Einstiegspunkt für alle Doku- und HowTo-Dateien.
- Querverweise sind Empfehlungen für vertiefende oder verwandte Themen.
- Bitte bei neuen HowTos/ADRs immer hier ergänzen!

**Pflegehinweis (Stand: 07.06.2025):**
- Nach jedem neuen HowTo, Lessons Learned oder Refactoring ist diese Matrix zu aktualisieren.
- Querverweise und Einträge zu neuen oder geänderten Doku-Dateien sind verpflichtend.
- Die Matrix bleibt der zentrale Einstiegspunkt für alle Doku- und HowTo-Dateien.

---

## Hinweis zu ADRs (Architecture Decision Records)

**ADRs (Architecture Decision Records) sind ab sofort verbindlicher Bestandteil der Projektdokumentation.**
- Jede relevante Architektur- oder Technologieentscheidung wird als ADR im Verzeichnis `.documents/decisions/` dokumentiert.
- Die Doku-Matrix enthält für jede ADR einen eigenen Eintrag und Querverweise zu den betroffenen HowTos und Architektur-Dokumenten.
- Bei jeder neuen Entscheidung oder Änderung: ADR anlegen oder aktualisieren und in die Matrix aufnehmen!
- ADRs sind Startpunkt für Review, Refactoring und Weiterentwicklung.

**Siehe Beispiele:**
- `.documents/decisions/adr-002-clean-architecture.md` (Layer, State-Management, DI)
- `.documents/decisions/adr-001.md` (Beispielstruktur)

---

<!--
Siehe auch:
- README.md (Projektüberblick)
- CONTRIBUTING.md (Doku- und Coding-Guidelines)
- GETTING_STARTED.md (Schnellstart und Doku-Einstieg)
-->

| Thema | Dokumentation |
|-------|---------------|
| Appweites Refactoring & God-Class-Vermeidung | [APPWIDE_REFACTORING_GUIDE.md](../APPWIDE_REFACTORING_GUIDE.md) |
