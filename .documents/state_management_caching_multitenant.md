# State-Management, Caching und RSS-Abruf im Multi-Tenant-Setup

## 1. Überblick
Dieses Dokument beschreibt das Zusammenspiel von Riverpod-Providern, Caching und RSS-Abruf-Mechanismen im Kontext des Multi-Tenant-Setups der App. Es werden die wichtigsten Provider, deren Caching-Verhalten und die Auswirkungen eines Tenant-Wechsels erläutert. Außerdem werden Empfehlungen für die Invalidierung und Wiederverwendung von Inhalten gegeben.

---

## 2. Provider und RSS-Abruf
- Die Provider `podcastCollectionProvider` und `podcastEpisodeProvider` sind für das Laden der Podcast-Collections und -Episoden zuständig.
- Beide Provider nutzen das zentrale Repository-Pattern (siehe `lib/data/repositories/`), das sowohl API- als auch RSS-Abrufe kapselt.
- Der eigentliche Abruf der RSS-Inhalte erfolgt im Repository (z.B. `ApiPodcastRepository`), das von den Providern aufgerufen wird.
- Die HostsPage und andere UI-Widgets greifen immer über diese Provider auf die Daten zu – ein direkter RSS-Abruf in der UI findet nicht statt.

**Querverweise:**
- [README.md](../README.md#repository-pattern--flexible-api-parameter-zukunftssicher)
- [lib/application/providers/podcast_provider.dart](../lib/application/providers/podcast_provider.dart)
- [lib/data/repositories/api_podcast_repository.dart](../lib/data/repositories/api_podcast_repository.dart)

---

## 3. Caching und Wiederverwendung von Inhalten
- Bereits geladene Inhalte (z.B. Episoden, Collections) werden im lokalen Cache (Hive, siehe `LocalCacheClient`) gespeichert.
- Beim erneuten Abruf (z.B. nach Tenant-Wechsel oder erneutem Öffnen der HostsPage) prüft das Repository, ob ein frischer Cache (max. 12h alt) existiert.
- Ist der Cache gültig, werden die Inhalte sofort wiederverwendet – ein erneuter RSS- oder API-Abruf ist nicht nötig.
- Ein explizites Cache-Clearing ist **nicht** vorgesehen und auch nicht erwünscht, da dies die Performance und Offline-Fähigkeit verschlechtern würde.

**Querverweise:**
- [README.md](../README.md#audio-player-teststrategie--lessons-learned-juni-2025)
- [lib/data/api/local_cache_client.dart](../lib/data/api/local_cache_client.dart)
- [lib/data/repositories/api_podcast_repository.dart](../lib/data/repositories/api_podcast_repository.dart)

---

## 4. ProviderScope und RSS-Abrufe
- Der ProviderScope steuert die Lebensdauer und den State aller Provider.
- Ein Wechsel des ProviderScope (z.B. durch einen neuen Key) führt dazu, dass alle darunterliegenden Provider und deren State neu initialisiert werden.
- RSS-Abrufe (bzw. deren Ergebnisse) werden dadurch ebenfalls neu geladen, **sofern kein gültiger Cache existiert**.
- Die HostsPage nutzt die Provider, um die RSS-Inhalte tenant-spezifisch anzuzeigen. Ein Wechsel des Tenants oder ein neues ProviderScope sorgt für einen Reload der Inhalte (mit Cache-Check).

**Querverweise:**
- [README.md](../README.md#state-management-caching-und-rss-abruf-im-multi-tenant-setup)
- [lib/application/providers/collection_provider.dart](../lib/application/providers/collection_provider.dart)

---

## 5. Empfehlungen für Multi-Tenant- und State-Management
- Beim Tenant-Wechsel sollten alle tenant-abhängigen Provider invalidiert werden:
  ```dart
  ref.invalidate(collectionIdProvider);
  ref.invalidate(podcastCollectionProvider);
  ref.invalidate(podcastEpisodeProvider);
  ref.invalidate(currentEpisodeProvider);
  ```
- Bereits geladene Inhalte werden automatisch wiederverwendet, solange sie im Cache sind.
- Ein explizites Cache-Clearing ist nicht nötig und nicht empfohlen.
- Ein neuer ProviderScope ist nur bei sehr speziellen Multi-Tenant-Setups nötig (z.B. parallele Tenants).

---

## 6. Weiterführende Doku & Querverweise
- [README.md](../README.md)
- [lib/data/repositories/api_podcast_repository.dart](../lib/data/repositories/api_podcast_repository.dart)
- [lib/data/api/local_cache_client.dart](../lib/data/api/local_cache_client.dart)
- [.documents/howto_merge_caching.md](../.documents/howto_merge_caching.md)
- [.instructions/adr-001-merge-strategy.md](../.instructions/adr-001-merge-strategy.md)
- [.instructions/prd_white_label_podcast_app.md](../.instructions/prd_white_label_podcast_app.md)

---

*Letzte Aktualisierung: 23.06.2025*
