# Netzwerkabrufe, Provider und Persistenz – Analyse und Übersicht

## 1. Provider- und Repository-Architektur
- Zentrale Provider: 
  - `podcastCollectionProvider` (lädt PodcastCollection per collectionId)
  - `podcastEpisodeProvider` (lädt Episoden per collectionId)
  - Beide Provider nutzen das zentrale Repository-Pattern (`PodcastRepository`)
  - Implementierungen: `ApiPodcastRepository`, `MockPodcastRepository`, (optional: `CachedPodcastRepository`)
  - Provider geben das Ergebnis-Limit aus dem zentralen `itunesResultCountProvider` weiter

## 2. Ablauf: Top-Down Datenabruf & Persistenz
1. **Provider** (z.B. `podcastCollectionProvider`) fragt das Repository an
2. **Repository** prüft lokalen Cache (Hive, TTL, z.B. 12h)
   - Wenn Cache frisch: Daten sofort verwenden
   - Sonst: API-Abruf (iTunes), dann RSS (über feedUrl aus iTunes), dann Merge mit JSON (about.json)
   - Nach jedem erfolgreichen Abruf: Speichern in Hive inkl. Timestamp (`downloadedAt`)
   - Bei Fehler/Offline: Fallback auf letzten Hive-Stand, dann Placeholder
3. **MergeService** führt Datenquellen zusammen (Priorität: about.json > iTunes > RSS)
4. **Cache-Services**:
   - `LocalCacheClient` (Hive, für PodcastCollection/Episoden)
   - `MergedCollectionCacheService` (Hive, für gemergte PodcastHostCollection)
   - `EpisodePagingCacheService` (Paging, pro CollectionId+PageIndex)
5. **UI** greift ausschließlich über Provider auf persistente Modelle zu

## 3. Timestamp- und Cache-Handling
- Jeder Abruf und jede persistente Entität erhält einen Timestamp (`downloadedAt`)
- Cache-Services prüfen TTL (z.B. 12h für Collections, 1h für Episoden-Paging)
- Nach jedem erfolgreichen Abruf/Merge wird der Timestamp aktualisiert und gespeichert
- Beispiel: `MergedCollectionCacheService.save()` speichert `{ data, timestamp }` pro collectionId

## 4. RSS-Fetching und Fallback-Logik
- Nach iTunes-Abruf wird (falls nötig) der RSS-Feed (über feedUrl) geladen
- RSS-Parsing und Caching via `RssParserService`, `RssService`, `rssMetadataProvider`
- Fallback-Logik: Wenn iTunes-API < 200 Episoden liefert, kann RSS als Fallback für alle Folgen genutzt werden
- Merge-Logik: Felder werden nach Priorität gemappt (siehe MergeService)

## 5. Quellcode- und Doku-Querverweise
- Provider: `lib/application/providers/podcast_provider.dart`, `lib/application/providers/repository_provider.dart`
- Repositories: `lib/data/repositories/api_podcast_repository.dart`, `lib/data/repositories/podcast_repository.dart`, `lib/data/repositories/mock_podcast_repository.dart`
- Cache: `lib/data/api/local_cache_client.dart`, `lib/core/services/merged_collection_cache_service.dart`, `lib/core/services/episode_paging_cache_service.dart`
- Merge: `lib/core/services/merge_service.dart`, `lib/core/services/collection_merge_service.dart`
- RSS: `lib/core/utils/rss_parser_service.dart`, `lib/core/utils/rss_service.dart`, `lib/application/providers/rss_metadata_provider.dart`
- Doku: `.documents/state_management_caching_multitenant.md`, `.instructions/howto_rss_fallback_episodes.md`, `.instructions/howto_merge_caching.md`, `.documents/riverpod_provider_architektur.mmd`, `.documents/riverpod_provider_podcast.mmd`

---

*Letzte Aktualisierung: 09.07.2025*
