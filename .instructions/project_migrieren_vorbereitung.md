## 📝 Migrationsleitfaden: Projektdokumentation & HowTos auf Template-Struktur bringen

**Ziel:**  
Alle projektspezifischen Markdown-Dateien (.md) und HowTos werden so vorbereitet, dass sie sich reibungslos und konsistent in das neue Template-Dokumentationssystem übernehmen lassen.

---

### Schritt 1: Zielstruktur & Prinzipien vorstellen

- **Präsentiere die Zielstruktur** (z. B. in einem README-Abschnitt, Team-Post oder als LLM-Prompt):

  > **Neue Doku-Struktur (Beispiel):**
  > ```
  > .documents/
  >   architecture_clean_architecture.md
  >   project_structure_best_practices.md
  >   howto_feature_x.md
  >   decisions/
  >     adr-001-something.md
  > .instructions/
  >   build.md
  >   setup.md
  >   ci_cd.md
  >   prompt.md
  > README.md
  > CONTRIBUTING.md
  > GETTING_STARTED.md
  > ```
  > - **Jede Anleitung/HowTo als eigene Datei** (z. B. `howto_audio_player.md`)
  > - **Keine doppelten oder veralteten Inhalte**
  > - **Querverweise und Links zu zentralen Doku-Dateien ergänzen**
  > - **Siehe `.documents/principles_matrix.md` für alle Prinzipien**

---

### Schritt 2: Projektspezifische Doku sichten & sortieren

- **Gehe alle bestehenden .md-Dateien durch** (README, HowTos, Build-Guides, ADRs etc.).
- **Sortiere sie thematisch**:
  - Architektur, Prinzipien → `.documents/`
  - HowTos, Anleitungen → `.documents/` oder `.instructions/`
  - Build/Setup/CI → `.instructions/`
  - Entscheidungen/ADRs → `.documents/decisions/`
- **Kennzeichne veraltete oder redundante Inhalte** (z. B. mit `ARCHIVIERT:` im Dateinamen oder als Kommentar im Dokument).

---

### Schritt 3: Migrationstaugliche Dateien erstellen

- **Jede projektspezifische Anleitung als eigene, klar benannte Datei anlegen** (z. B. `howto_feature_flag.md`).
- **Doppelte oder veraltete Inhalte entfernen oder zusammenführen**.
- **Querverweise auf zentrale Doku ergänzen** (z. B. „Siehe `.documents/architecture_clean_architecture.md`“).
- **Formatierung und Kommentarstil an das Template anpassen** (prägnant, LLM-freundlich, mit Beispielen und Quellen).
- **Optional:** Eine Übersichtstabelle oder Matrix aller HowTos und Doku-Dateien anlegen.

---

**Prompt für LLMs/Teams:**  
> „Bitte prüft alle projektspezifischen .md-Dateien und bringt sie in die oben beschriebene Zielstruktur. Jede Anleitung/HowTo als eigene Datei, veraltete Inhalte kennzeichnen oder entfernen, Querverweise ergänzen. Ziel: Migration auf das neue Template-Dokumentationssystem ohne Redundanz und mit maximaler Übersichtlichkeit.“

---

**Tipp:**  
Nutze diese Präsentationsform als Team-Checkliste, LLM-Prompt oder als Vorlage für ein Migrations-Ticket.  
So ist der Prozess für alle Beteiligten klar, nachvollziehbar und automatisierbar!  > .documents/
  >   architecture_clean_architecture.md
  >   project_structure_best_practices.md
  >   howto_feature_x.md
  >   decisions/
  >     adr-001-something.md
  > .instructions/
  >   build.md
  >   setup.md
  >   ci_cd.md
  >   prompt.md
  > README.md
  > CONTRIBUTING.md
  > GETTING_STARTED.md
  > ```
  > - **Jede Anleitung/HowTo als eigene Datei** (z. B. `howto_audio_player.md`)
  > - **Keine doppelten oder veralteten Inhalte**
  > - **Querverweise und Links zu zentralen Doku-Dateien ergänzen**
  > - **Siehe `.documents/principles_matrix.md` für alle Prinzipien**

---

### Schritt 2: Projektspezifische Doku sichten & sortieren

- **Gehe alle bestehenden .md-Dateien durch** (README, HowTos, Build-Guides, ADRs etc.).
- **Sortiere sie thematisch**:
  - Architektur, Prinzipien → `.documents/`
  - HowTos, Anleitungen → `.documents/` oder `.instructions/`
  - Build/Setup/CI → `.instructions/`
  - Entscheidungen/ADRs → `.documents/decisions/`
- **Kennzeichne veraltete oder redundante Inhalte** (z. B. mit `ARCHIVIERT:` im Dateinamen oder als Kommentar im Dokument).

---

### Schritt 3: Migrationstaugliche Dateien erstellen

- **Jede projektspezifische Anleitung als eigene, klar benannte Datei anlegen** (z. B. `howto_feature_flag.md`).
- **Doppelte oder veraltete Inhalte entfernen oder zusammenführen**.
- **Querverweise auf zentrale Doku ergänzen** (z. B. „Siehe `.documents/architecture_clean_architecture.md`“).
- **Formatierung und Kommentarstil an das Template anpassen** (prägnant, LLM-freundlich, mit Beispielen und Quellen).
- **Optional:** Eine Übersichtstabelle oder Matrix aller HowTos und Doku-Dateien anlegen.

---

**Prompt für LLMs/Teams:**  
> „Bitte prüft alle projektspezifischen .md-Dateien und bringt sie in die oben beschriebene Zielstruktur. Jede Anleitung/HowTo als eigene Datei, veraltete Inhalte kennzeichnen oder entfernen, Querverweise ergänzen. Ziel: Migration auf das neue Template-Dokumentationssystem ohne Redundanz und mit maximaler Übersichtlichkeit.“

---

**Tipp:**  
Nutze diese Präsentationsform als Team-Checkliste, LLM-Prompt oder als Vorlage für ein Migrations-Ticket.  
So ist der Prozess für alle Beteiligten klar, nachvollziehbar und automatisierbar!