<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# Schritt 4: Paging- und Listen-Caching für Episoden (Hive, TTL, Provider)

## Ziel
- Effizientes Paging- und Listen-Caching für große, dynamisch geladene Listen (z. B. Episoden)
- Kein erneutes, teures Nachladen beim Scrollen nach oben/unten
- Persistenz und TTL pro Seite (z. B. 1h)
- Provider-Architektur für einfache Testbarkeit und Erweiterbarkeit

## Hive-Schema
- Box: `episodePagesBox`
- Key: `collectionId_pageIndex` (z. B. `1590516386_0`)
- Value:
```json
{
  "data": [ ...Episode-Objekte als JSON... ],
  "timestamp": "2025-05-27T12:34:56.000"
}
```
- TTL: 1 Stunde pro Seite

## Architektur
- Service: `EpisodePagingCacheService` (Hive, TTL, Save/Load/Invalidate pro Seite)
- Provider: `episodePagingProvider` (StateNotifier, verwaltet Episodenliste, Paging-Status, Fehler)
- Kombiniert Seiten zu einer vollständigen Liste für die UI

## Teststrategie
- Mock für Netzwerk und Cache
- Tests für: „Cache leer“, „Cache frisch“, „Cache abgelaufen“, „Netzwerkfehler“, „Seiten kombinieren“

# Teststrategie: Fallback/Placeholder & Mocking (Mai 2025)

- Für Paging-Provider und -Services gilt das gleiche Testpattern wie für FeatureFlags:
  - ProviderContainer mit passenden Overrides für Cache/Storage/Netzwerk.
  - Asynchrone Initialisierung beachten: Im Test mit container.listen auf State-Änderung warten oder Delay einbauen.
  - Mock-Implementierungen für Cache und Netzwerk, um alle Fallback-Ketten (Cache, Netzwerk, Placeholder) zu testen.
- Testfälle:
  - Cache leer → Fallback auf Netzwerk/Placeholder
  - Cache frisch → Daten aus Cache
  - Cache abgelaufen → Fallback auf Netzwerk, ggf. Placeholder
  - Netzwerkfehler → Fallback auf Cache/Placeholder
  - Seiten kombinieren und State korrekt halten
- Siehe auch Testfälle in `test/core/services/episode_paging_cache_service_test.dart` und `test/application/providers/episode_paging_provider_test.dart`.
- Pattern ist für alle Listen-/Paging-Provider wiederverwendbar.

## Beispiel
```dart
final notifier = ref.read(episodePagingProvider.notifier);
notifier.loadPage(0, fetchPageFromApi);
```

## Nächste Schritte
- Integration in die UI (z. B. PodcastPage)
- Tests für Paging- und Cache-Logik
- Übertragbarkeit auf andere Listen (z. B. Suchergebnisse, Hosts)

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: Paging- und Listen-Caching für Episoden (Hive, TTL, Provider) inkl. Teststrategie und TTL-Konzept.
- Siehe auch: `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Testfälle und Patterns für Paging-Provider und -Services sind im Altprojekt dokumentiert.
