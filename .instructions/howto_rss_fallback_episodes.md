# HowTo: Mehr als 200 Podcast-Folgen per RSS-Fallback laden

## Problemstellung
- Die iTunes Search API liefert maximal 200 Folgen pro Anfrage, unterstützt aber kein Paging/Offset.
- Viele Podcasts haben deutlich mehr als 200 Folgen.
- Ziel: Alle Folgen (auch >200) effizient und zukunftssicher abrufen und anzeigen.

## Status Quo im Projekt
- RSS-Parsing ist bereits vorhanden (`rss_parser_service.dart`, `rss_service.dart`).
- Merge-Logik für iTunes- und RSS-Daten existiert (`merge_service.dart`).
- Caching für RSS-Feeds ist implementiert (TTL-basiert).

## Lösung: RSS-Fallback für Episoden

### 1. Fallback-Logik im Repository/Service
- Nach dem iTunes-API-Call prüfen, ob die Episodenanzahl >= 200 ist (oder auf User-Wunsch immer RSS nutzen).
- Falls ja: RSS-Feed laden (mit Caching) und alle Episoden daraus extrahieren.
- Mapping der RSS-Episoden ins bestehende `PodcastEpisode`-Modell.
- Merge der Metadaten (Cover, Beschreibung etc.) aus iTunes und RSS.

### 2. Mapping-Logik
- Hilfsfunktion schreiben, die aus einem RSS-Feed (`webfeed` oder eigener Parser) eine Liste von `PodcastEpisode` erzeugt.
- Felder wie Titel, Beschreibung, Audio-URL, Veröffentlichungsdatum, Bild etc. auslesen und zuweisen.
- Defensive Programmierung: Nicht jeder Feed hat alle Felder, daher Fallbacks nutzen.

### 3. Caching & Abrufkosten
- Bestehendes Caching im `RssParserService`/`RssService` nutzen.
- Sinnvolle TTL (z. B. 12–24h) setzen, um Abrufkosten gering zu halten.

### 4. Merge-Strategie
- Im `MergeService` oder Repository:
  - Wenn RSS-Fallback aktiv, Episoden-Liste im `Podcast`-Modell ersetzen/ergänzen.
  - Metadaten (z. B. Cover, Beschreibung) priorisiert aus iTunes oder RSS übernehmen.

### 5. UI/Provider
- Optional: In den Preferences eine Option „Alle Folgen anzeigen (RSS-Fallback)“ anbieten.
- Provider/Repository gibt dann die vollständige Liste zurück.

## Podcast-RSS-spezifische Details
- Felder: `guid`/`link` (ID), `enclosure.url` (Audio), `title`, `description`, `pubDate`, `itunes:image`, `itunes:duration`.
- Unterschiedliche Namenskonventionen beachten (z. B. `itunes:episode` vs. `title`).
- Defensive Programmierung: Felder können fehlen oder anders benannt sein.

## Querverweise
- `lib/core/utils/rss_parser_service.dart`
- `lib/core/utils/rss_service.dart`
- `lib/core/services/merge_service.dart`
- `lib/domain/models/podcast_episode_model.dart`
- `lib/domain/models/podcast_collection_model.dart`
- `lib/application/providers/rss_metadata_provider.dart`

## Fazit
- Die technische Basis ist vorhanden, die Erweiterung ist mittelgroß, aber sehr gut in die bestehende Architektur integrierbar.
- Die Abrufkosten bleiben durch Caching und gezielten Abruf gering.
- Die Lösung ist zukunftssicher und kann für andere Plattformen/Feeds adaptiert werden.

---

**Nächste Schritte:**
- Mapping-Funktion für RSS-Episoden implementieren.
- Fallback-Logik im Repository/Service ergänzen.
- Merge-Strategie und UI-Optionen ggf. erweitern.
- Tests und Doku aktualisieren.
