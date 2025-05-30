# HowTo: Migration der Projektdokumentation in ein neues Template

## Einleitung: Vorbereitung für eine erfolgreiche Doku-Migration

Bevor du die eigentliche Migration startest, empfiehlt es sich, im alten Projekt (Quellprojekt) das neue Template und dessen Doku-/Struktur kurz vorzustellen. Bitte das Team (oder dich selbst, falls du allein arbeitest), alle projektspezifischen Markdown-Dateien (.md) und Doku-HowTos in eine möglichst „migrationstaugliche“ Ausgangslage zu bringen. 

**Ziel:**
- Redundanzen und veraltete Inhalte vorab bereinigen
- Thematische Sortierung und klare Benennung der Doku-Dateien
- HowTos, Architektur- und Entscheidungsdokumente als eigenständige, klar benannte Dateien anlegen
- Projektspezifische Besonderheiten kennzeichnen

Diese Vorbereitung erleichtert die eigentliche Migration, reduziert Konflikte und sorgt für eine nachhaltige, konsistente und LLM-freundliche Dokumentationslandschaft im neuen Projekt.

---

## Leitfaden: Migration & Migrationsmatrix für Projektdokumentation

### Ziel
Dieser Leitfaden beschreibt, wie du die Dokumentation (Markdown-Dateien, HowTos, Architekturentscheidungen etc.) aus einem bestehenden Projekt in die Doku-Struktur dieses Templates überführst. Er enthält Empfehlungen zur Vorbereitung, zur Erstellung einer Migrationsmatrix und zum eigentlichen Migrationsprozess.

---

### 1. Vorbereitung
- **Zielstruktur klären:**
  - Siehe `.documents/` und `.instructions/` in diesem Template als Referenz.
  - Jede Anleitung, HowTo oder Entscheidung als eigene, klar benannte Datei anlegen.
- **Alte Doku sichten:**
  - Verschaffe dir einen Überblick über alle relevanten `.md`-Dateien im Quellprojekt (z. B. per Dateibaum oder Skript).
  - Sortiere die Dateien thematisch (Architektur, HowTos, ADRs, Build, Setup, Status/PRD).
- **Redundanzen und Altlasten bereinigen:**
  - Veraltete oder doppelte Inhalte kennzeichnen oder entfernen.
  - Projektspezifische Besonderheiten markieren.

---

### 2. Migrationsmatrix erstellen
- **Zweck:**
  - Die Migrationsmatrix dokumentiert, welche Datei aus dem Quellprojekt wohin im Template übernommen wird.
  - Sie dient als Checkliste und Nachweis für die Migration.
- **Empfohlene Form (Markdown-Tabelle):**

| Alte Datei (Quellprojekt)         | Neue Datei (Template)                        | Status/Bemerkung                |
|-----------------------------------|----------------------------------------------|----------------------------------|
| architecture.md                   | .documents/architecture_clean_architecture.md| Inhalt übernommen/angepasst      |
| howto_audio_player.md             | .documents/howto_audio_player.md             | 1:1 übernommen                   |
| instructions.md                   | .documents/project_structure_best_practices.md| zusammengeführt mit ...          |
| ...                               | ...                                          | ...                              |

- **Tipp:**
  - Die Matrix kann in `.instructions/merge_decisions_and_field_sources.md` oder als eigene Datei gepflegt werden.

---

### 3. Migration durchführen
1. **Dateien gemäß Matrix verschieben/umbenennen**
   - Nutze Skripte oder manuelle Aktionen, um die Dateien in die Zielstruktur zu bringen.
2. **Inhalte anpassen**
   - Querverweise, Links und Formatierung an die Konventionen des Templates anpassen.
   - Kommentarstil und Beispiele ggf. angleichen.
3. **README und Matrix aktualisieren**
   - Die Übersichtstabelle/Matrix in `.documents/README.md` ergänzen.
   - Die Migrationsmatrix als Nachweis beilegen.
4. **Review & Commit**
   - Linting und Formatierung prüfen.
   - Migration dokumentieren und committen.

---

### 4. Best Practices
- Migration iterativ und nachvollziehbar durchführen (kleine Schritte, häufige Commits).
- Die Migrationsmatrix als zentrale Checkliste und Nachweis nutzen.
- Nach der Migration alle Querverweise und Übersichten aktualisieren.
- Bei Unsicherheiten: Siehe Prinzipienmatrix und README.

---

### 5. Nachbereitung & Qualitätssicherung

- In jedem HowTo, ADR und Architektur-Dokument am Anfang einen Hinweis auf die Doku-Matrix und ggf. verwandte Dateien ergänzen (z. B. „Siehe auch: doku_matrix.md“).
- Die Doku-Matrix (`doku_matrix.md` oder `.documents/README.md`) bei jeder Änderung aktuell halten.
- In `CONTRIBUTING.md` und `GETTING_STARTED.md` die neue Doku-Struktur, die Matrix und das Vorgehen für neue Doku/HowTos beschreiben.
- Abschließend einen Review durchführen, ob alle Querverweise, die Matrix und die README.md aktuell und konsistent sind.
- Optional: Noch vorhandene Redundanzen oder veraltete Doku identifizieren und mit `ARCHIVIERT:` kennzeichnen oder entfernen.

---

**Hinweis:**
Dieser Leitfaden kann für jede künftige Doku-Migration als Vorlage genutzt werden. Passe die Matrix und die Schritte bei Bedarf an die Projektsituation an.
