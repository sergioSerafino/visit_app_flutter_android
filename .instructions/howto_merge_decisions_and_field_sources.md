# MergeService: Entscheidungsdokumentation & Feldherkunft

<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_merge_caching.md, adr-001-merge-strategy.md -->

## 1. Feldquellen und Merge-Strategie

### a) collectionId
- **Quelle:** iTunes API (Hauptquelle)
- **Bedeutung:** Eindeutiger Schlüssel für alle Podcast-bezogenen Daten. Wird als "Source of Truth" für alle weiteren Datenflüsse verwendet.
- **Hinweis:** Wird niemals leer verwendet. Falls keine gültige collectionId, wird das Objekt nicht als Hauptkontext geladen.

### b) feedUrl
- **Quelle:** iTunes API (direkt im Podcast-Objekt)
- **Bedeutung:** Essenziell für den RSS-Abruf. Ohne feedUrl kein RSS-Merge möglich.
- **Hinweis:** feedUrl ist die zweitwichtigste Stelle nach collectionId. Wird im StateProvider und im MergeService als Schlüssel verwendet.

### c) about.json & host_model.json
- **Quelle:**
  - Ursprünglich: about.json als generisches Zusatz-JSON pro Tenant.
  - host_model.json: Zweite, strukturierte Revision für Host-bezogene Daten.
  - **Aktuell:** Beide werden zusammengeführt (Merge zu LocalJsonData), um alle nicht-iTunes- und nicht-RSS-Felder zu kapseln.
- **Bedeutung:**
  - Dient als Fallback und Ergänzung für Felder, die nicht aus iTunes oder RSS kommen.
  - Felder wie authTokenRequired, featureFlags, Branding, Localization, Content etc. werden hier gepflegt.
- **Hinweis:**
  - Die Zusammenführung ist notwendig, weil about.json historisch "Auffangbecken" für alle Zusatzinfos war, die nicht in die strukturierte host_model.json passten.
  - Die aktuelle Merge-Strategie sieht vor, dass LocalJsonData alle relevanten Felder aus beiden Quellen aggregiert.

## 2. Feldherkunft im MergeService (Beispiele)

| Feld                   | Quelle (Priorität)         | Bemerkung |
|------------------------|----------------------------|-----------|
| collectionId           | iTunes                     |           |
| collectionName         | iTunes                     |           |
| artistName             | iTunes                     |           |
| primaryGenreName       | iTunes                     |           |
| artworkUrl600          | iTunes                     |           |
| feedUrl                | iTunes                     |           |
| episodes               | iTunes                     |           |
| hostName               | iTunes (artistName)        |           |
| description            | RSS > LocalJson > ''       |           |
| contact.email          | RSS > LocalJson            |           |
| contact.websiteUrl     | RSS > LocalJson            |           |
| branding.logoUrl       | RSS (Cover) > iTunes (artworkUrl600) > LocalJson | logoUrl aus RSS ist meist sehr groß, artworkUrl600 ist Standard |
| branding.primaryColor  | LocalJson                  | Für dynamisches Theming |
| branding.secondaryColor| LocalJson                  | Für dynamisches Theming |
| headerImageUrl         | LocalJson                  | Optional, für Layout |
| themeMode              | LocalJson                  | Kundenpräferenz für App-Design |
| features               | LocalJson                  | Feature-Flags für UI |

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: Entscheidungsdokumentation & Feldherkunft für den MergeService, inkl. Mapping-Tabellen und Querverweise.
- Siehe auch: `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_merge_caching.md`, `adr-001-merge-strategy.md` (siehe Altprojekt).
