# Analyse: Podcast-Caching und User-Trigger für HivePage

## 1. Priorisierung und Merge der Mediendaten
- **iTunes API:** Liefert `collectionId` und Basis-Metadaten (Cover, Genre, Feed-URL).
- **RSS:** Liefert Detaildaten (Beschreibung, Episoden, Kontakt, Logo, etc.).
- **Lokale JSON:** Ergänzt/ersetzt Felder wie FeatureFlags, Branding, Localization.
- **MergeService/CollectionMergeService:** Führen die Datenquellen zu einem vollständigen Modell zusammen (`mergePodcastData`, `buildPodcastHostCollectionFromSources`).

## 2. Datenquellen im Code
- **iTunes:** Abruf über Methoden in `api_client.dart` und `api_podcast_repository.dart` (Endpunkte/Parameter: `api_endpoints.dart`).
- **RSS:** Abruf/Parsing über `rss_service.dart` und `rss_parser_service.dart` (Fehler/Redirects werden robust behandelt).
- **Lokal:** Laden über `placeholderLoader.loadLocalJsonData(collectionId)` im MergeService.

## 3. Feldpriorität beim Merge
- Zentrale Felder wie `logoUrl`, `contact.email`, `description` werden nach Schema RSS > iTunes > LocalJson gemerged.
- Siehe Doku/Tests: `merge_service_rss_integration_test.dart`, `rss_parser_service_test.dart`.

## 4. Persistenz und UI-Nutzung
- Nach dem Merge werden vollständige Modelle (`PodcastHostCollection`, `PodcastCollection`, `PodcastEpisode`) in Hive gespeichert.
- Die UI greift nur auf gemergte, persistente Modelle zu (Ziel: keine Einzelabrufe/Provider-Logik mehr in Widgets, sondern gezielte Updates über Timestamps/TTL).
- Fallbacks/Placeholder nur, wenn keine echten Daten verfügbar sind.

## 5. Konsistenz und Aktualität
- Caching-Strategie mit TTL und `downloadedAt`-Timestamp (siehe Hive-Plan/Doku).
- Nach jedem erfolgreichen Abruf werden die Daten aktualisiert und persistiert.
- Offline-Fallback: Anzeige aus Cache, sonst Placeholder.

## 6. Fehlerbehandlung/Edge Cases
- Merge-/Parsing-Logik ist defensiv und testbar (siehe Tests/Doku).
- Fehler beim Abruf (RSS-Redirects, API-Limits) werden durch Fallbacks/Placeholder abgefangen.
- Netzwerk-Retrier mit `connectivity_plus` und Interceptor für nutzerfreundliche Verbindung.

---

## IST-Zustand
- Ein-Kommentieren von `savePodcastCollection`/`savePodcastEpisodes` zeigt auf HivePage keine gespeicherten podcastBox-Datensätze ('Keine Einträge vorhanden').
- Erwartet: Key-Value-Struktur der podcastBox:
  - **Key:** `collectionId` (String)
  - **Value:** serialisiertes Objekt `PodcastCollection`/`Podcast` (inkl. Felder/Episoden)
- In der App: Episoden-Liste ist befüllt, andere Felder (iTunes-Collection: `artistName`, `artworkUrl600`, `primaryGenreName`) fehlen, Fallback auf Placeholder.
- RSS-Abruf schlägt fehl, keine Snackbar-Nachricht, Felder bleiben leer/Placeholder.

## SOLL-Zustand
- User-Trigger auf HivePage soll gezielt den Netzwerkabruf für alle relevanten Mediendaten (PodcastCollection, Podcast, Episoden) auslösen.
- UI bleibt wie bisher: PodcastCollection und Podcast werden getrennt dargestellt, aber der podcastBox-Datensatz ist derselbe.
- Erweiterung: User-Trigger kann später auch Plattform-/Konfigurationsdaten ins Caching einbeziehen (Migration zu podcastHostCollectionBox).

## Abgleich IST/SOLL und nächste Schritte
1. **Analyse:**
   - Prüfe, ob die Methoden in `local_cache_client.dart` und ggf. `merged_collection_cache_service.dart` die Datenquellen wie gewünscht bündeln und abrufen können.
   - Prüfe, ob ein übergeordneter Service (z. B. LocalStorageService/CacheService) existiert oder ergänzt werden sollte.
2. **User-Trigger:**
   - Implementiere auf HivePage ein UI-Trigger, für ein gezieltes Zusammenspiel mit den Datenaufrufern (`lokal`, zunächst vor allem `api`, `rss`) für den Abruf und das Speichern der Mediendaten (von zunächst iTunes -> `podcastBox`) mit den üblichen CRUD-Befehlen.
   - Dokumentiere, welche Datenquellen abgerufen werden und wie die Persistenz erfolgt.
3. **Testen:**
   - Nach jedem Trigger: HivePage prüfen, ob die Einträge sichtbar sind.
   - UI auf allen Seiten (PodcastPage, HostsPage, etc.) testen.
4. **Migration:**
   - Schrittweise Umstellung von podcastBox auf podcastHostCollectionBox, inkl. Plattform-/Konfigurationsdaten.
   - Doku und Lessons Learned laufend ergänzen.

---

**Empfohlene Datei:** `.documents/hive_cache_user_trigger_plan.md`

**Letztes Update:** 12.07.2025
