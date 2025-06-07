# ADR-003: Teststrategie, Lessons Learned & Doku-Integration

**Datum:** 31.05.2025
**Status:** angenommen
**Betrifft:** Teststrategie, Dokumentation, Migration

---

## Kontext
Im Rahmen der Migration des Projekts `storage_hold` in das Zielprojekt wurde eine umfassende Test- und Dokumentationsstrategie etabliert. Ziel ist eine lückenlose, nachvollziehbare und LLM-freundliche Doku, die alle Lessons Learned, Teststrategien und Erkenntnisse aus dem Quellprojekt abbildet und für die Weiterentwicklung nutzbar macht.

---

## Entscheidung
- Die Doku-Matrix bleibt zentraler Einstiegspunkt für alle Doku-, HowTo- und Entscheidungsdateien.
- Alle Lessons Learned, Teststrategien und Review-Checklisten aus dem Quellprojekt werden übernommen und laufend gepflegt.
- Die Teststrategie umfasst:
  - Vollständige Abdeckung aller Kernbereiche (Provider, Service, Integration, Audio, Cast/AirPlay, zentrale Widgets)
  - Widget- und Integrationstests mit Fokus auf State-Wechsel, UI-Robustheit und Accessibility
  - Dokumentation von Test-Limitierungen (z. B. Flutter-Semantics, Multiline-Labels)
  - Review- und Dubletten-Checklisten, Migrationsmatrix und offene Punkte werden laufend aktualisiert
- Alle relevanten HowTos (z. B. Merge, FeatureFlags, Paging, Naming, UI/Design, RSS) werden übernommen und in der Matrix verlinkt.
- ADRs werden für alle Architektur- und Testentscheidungen fortgeführt und in der Matrix gepflegt.
- Die Lessons Learned und Teststrategie werden explizit in der Doku (Status-Report, HowTos, ADRs) dokumentiert.

---

## Konsequenzen
- Die Test- und Doku-Qualität bleibt langfristig hoch und nachvollziehbar.
- Neue Features, Tests und Erkenntnisse werden systematisch dokumentiert und in die Matrix/ADRs aufgenommen.
- Die Migration ist lückenlos nachvollziehbar, alle Altprojekt-Aspekte sind integriert.
- Die Doku ist LLM- und Entwickler:innen-freundlich strukturiert.

---

## Querverweise
- Doku-Matrix (`.instructions/doku_matrix.md`)
- Status-Report (`.documents/status_report.md`)
- HowTos (z. B. `howto_merge_caching.md`, `howto_feature_flags.md`)
- PRD (`.documents/prd_white_label_podcast_app.md`)
- Review- und Migrationsmatrix (`.instructions/`)
- Audio-Architektur & Best Practices: `docs/audio_architektur_2025.md`, `docs/audio_player_best_practices_2025.md`

---

**Hinweis zur Doku-Pflege (Stand: 07.06.2025):**
Alle neuen Erkenntnisse, Lessons Learned und Teststrategien sind nach jedem Feature, Refactoring oder Review konsequent in die Doku-Matrix und die zentralen Doku-Dateien einzupflegen. Die Pflegepflicht und Querverweise sind verbindlich.

*Letztes Update: 31.05.2025 – Teststrategie und Lessons Learned aus der Migration als ADR dokumentiert.*
