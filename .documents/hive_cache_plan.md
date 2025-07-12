## Schritt 1: Datenquellen und Datenmodellebenen

### Frage 1: Priorisierung der Datenquellen

**Mediendaten-Ebene** (z. B. Podcasts, Episoden):

1. Placeholder (für ein gültigen UI Zustand)
2. Lokales JSON (bezieht sich in erster Linie auf Infos zum Host wird nach RSS-erhalt jedoch in das übergeordnete Objekt PodcastHostCollection aufgenommen und geschachtelt in Hive verwaltet)
3. Cache (Hive; `podcastBox` ist eine flache erste Persistenz aus key/values und soll erweitert werden um das neue strukturierterte HiveBox DB-design mit Adaptern)
4. iTunes Search API (Basis-Metadaten)
5. RSS (Detaildaten, Beschreibung, Episoden)

**Konfigurations-/Plattform-Ebene** (z. B. Branding, FeatureFlags, HostInfo):

1. Placeholder
2. JSON (statisch oder lokal gebundelt)
3. Cache (Hive)
4. iTunes API (teilweise HostName)
5. RSS (bei RSS-gestützten Hosts)

*Hinweis:* RSS-Daten sind besonders relevant für Mediendaten (Beschreibung, Feed-Infos, Episoden). Ein vollständiges Caching ist erst nach dem RSS-Abruf möglich. Deshalb kommt RSS in der Priorität später, wird aber entscheidend für die Merge-Komplettierung genutzt.

---

### Frage 2: TTL und Aktualisierungsstrategie

**Allgemein:**

- Gültigkeitsprüfung über `downloadedAt`-Feld im Modell.
- Audio-Dateien: 7 Tage lokal, Favoriten: bis zu 6 Monate (per Snackbar bestätigt)

**Mediendaten-Ebene:**

- iTunes-Daten: alle 12 Stunden (TTL)
- RSS-Daten: alle 12 Stunden, aber bei Bedarf auch länger (z. B. seltene Podcasts)
- JSON (lokal): aktualisiert sich nur mit App-Update
- Cache: bleibt erhalten, bis TTL abläuft oder explizit gelöscht wird

**Plattform-/Konfigurationsdaten:**

- Branding, FeatureFlags: alle 24h (länger gültig)
- Placeholder: bis erste Quelle verfügbar ist

---

## Schritt 2: Caching-Strategie und Fallback-Logik

### Frage 3: Zusammenspiel von Cache und Fallback

- **Reihenfolge:**

  1. Cache prüfen (HiveBox) →
  2. Wenn gültig: anzeigen
  3. Wenn abgelaufen oder leer: API/RSS/JSON laden →
  4. Nach erfolgreichem Merge: neue Daten in Cache speichern (`downloadedAt = now`)

- **Fehlerfall / kein Netz:**

  - Wenn Cache vorhanden: Anzeige aus Cache
  - Wenn kein Cache: Placeholder anzeigen
  - Snackbar: 'Keine Verbindung verfügbar – bitte später erneut versuchen.' / 'Offline-Modus aktiviert.'

- **Unterschied Mediendaten vs. Plattformdaten:**

  - Mediendaten haben oft Fallback auf leere Episode-Listen (→ leere UI)
  - Plattformdaten verwenden klarere Placeholder oder lokale Defaults

---

### Frage 4: Welche Daten werden explizit persistiert?

- Persistiert werden:
  - **PodcastHostCollection** als zentrales Objekt
  - **Podcast** (inkl. Artwork, Feed-URL, mit eigenem `downloadedAt`)
  - **Episodenliste**
    - Metadaten mit `metadataDownloadedAt`
    - Audio-Dateien mit `audioDownloadedAt`
  - **PodcastCollection** (z. B. für Suchergebnisse) mit `downloadedAt`
  - **HostInfo** (wird übergeordnet aktualisiert)
  - **FeatureFlags, Localization, Kontaktinfo, HostContent, Link** → keine eigenen Timestamps
  - **CollectionMeta** nutzt `lastSynced` (kein extra `downloadedAt`)
- Favoriten bleiben unabhängig von `downloadedAt` erhalten (siehe Snackbar)

---

### Zeitstempel-Übersicht (Tabelle)

| Modell                  | Eigener Timestamp     | Feldname                | Bemerkung                                              |
|------------------------|------------------------|-------------------------|--------------------------------------------------------|
| Podcast                | ✅ Ja                  | `downloadedAt`          | Für TTL (iTunes-Daten)                                 |
| PodcastEpisode         | ✅ Zwei Timestamps     | `metadataDownloadedAt`, `audioDownloadedAt` | Getrennt für Metadaten & Audio-Dateien       |
| PodcastHostCollection  | ✅ Ja (zentral)        | `downloadedAt`          | Gilt für gesamte Collection                            |
| PodcastCollection      | ✅ Ja                  | `downloadedAt`          | Für Listen- oder Such-Caching                          |
| CollectionMeta         | ✅ Funktional          | `lastSynced`            | Wird auch für TTL-Zwecke genutzt                       |
| Host                   | ❌ Nein                | —                       | Wird implizit über Collection aktualisiert             |
| Branding               | ❌ Nein                | —                       | Teil von Host, keine eigene TTL                        |
| FeatureFlags           | ❌ Nein                | —                       | Teil von Host                                          |
| LocalizationConfig     | ❌ Nein                | —                       | Teil von Host                                          |
| ContactInfo            | ❌ Nein                | —                       | Teil von Host                                          |
| HostContent            | ❌ Nein                | —                       | Teil von Host                                          |
| Link                   | ❌ Nein                | —                       | Teil von HostContent                                   |

---

## Schritt 3: UI-Integration und Datenfluss

### Frage 5: Umgang der Provider mit Datenquellen

- Provider liefern stets vollständige Modelle (egal ob aus API, Cache, Placeholder)
- Wichtig: Modelle dürfen nie `null` zurückgeben, sondern z. B. `PodcastHostCollection.empty()` oder `.isPlaceholder == true`
- UI entscheidet basierend auf Modell-Zustand, wie Inhalte dargestellt werden
- Snackbar informiert bei Offline/Fallback („Offline-Modus aktiviert“, „Sammlung konnte nicht geladen werden“)

### Frage 6: Idealer Datenfluss z. B. für LandingPage

1. **Appstart →** prüfen `collectionId` (aus Settings, DeepLink o. Ä.)
2. **Lokale JSON / Branding laden →** vorab UI gestalten
3. **Hive-Box prüfen (`podcastHostCollections`) →** gültig? → anzeigen
4. **API-Aufruf iTunes →** Ergebnis mergen
5. **RSS abrufen →** Details & Episoden ergänzen
6. **Merge durchführen →** mit lokaler JSON (about.json)
7. **Ergebnis in Hive speichern (`downloadedAt`) →** Provider aktualisieren UI
8. **Snackbar:** 'Sammlung aktualisiert – neue Episode(n) verfügbar.'

---

## Schritt 4: Lessons Learned und offene Fragen

### Frage 7: Typische Fehlerquellen bisher

- Cache war leer → App zeigte Platzhalter, obwohl z. B. iTunes bereits geladen war
- Provider prüften nicht konsistent auf `isPlaceholder` oder `isEmpty`
- Cache-Schreibvorgang teilweise deaktiviert → keine persistierten Daten
- Merge erfolgte nicht nach vollständigem RSS-Abruf → unvollständige Modelle
- UI zeigte leere Listen statt Hinweis

### Frage 8: Anforderungen an Nachvollziehbarkeit

- **Debug-UI oder Admin-Modus:**

  - Anzeigen: collectionId, downloadedAt, TTL-Zustand, Quelle (Meta)
  - Manuelle Refresh-Trigger
  - Listenansicht aller Hive-Einträge

- **Logging:**

  - Info bei Cache-Zugriff („Cache gültig“, „Fallback auf Placeholder“)
  - Merge-Ergebnisse (Quelle, Anzahl Episoden, Dauer)

- **Snackbar:**

  - z. B. 'Sammlung aktualisiert', 'Host-Profil wurde aktualisiert', 'Cache gelöscht', etc.
  - Hinweis auf Favoriten-Verhalten ('Favorit gespeichert – bleibt 6 Monate erhalten')