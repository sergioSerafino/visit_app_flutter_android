<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_collectionid_refactoring.md -->

# Schritt 5: CollectionRegistryService & CollectionId-Validierung

## Ziel
- Zentrale Verwaltung und Validierung aller verfügbaren CollectionIds (Mandanten/Hosts)
- Registry wird remote geladen (z. B. als JSON), lokal in Hive mit TTL gecacht
- Bei Fehlern/Offline: Fallback auf letzte gültige Kopie
- Provider für Registry und Validierung, testbar und lose gekoppelt

## Architektur
- Service: `CollectionRegistryService` (Hive, TTL, Save/Load/Invalidate, Remote-Fetch)
- Provider: `collectionRegistryProvider` (AsyncNotifier, lädt Registry, prüft Gültigkeit von CollectionIds)
- Integration: CollectionId-Provider prüft bei Änderung, ob neue Id gültig ist (sonst Fehler/Snackbar)

## Teststrategie
- Mock für Netzwerk und Cache
- Tests für: „Registry leer“, „Registry frisch“, „Registry abgelaufen“, „Netzwerkfehler“, „Validierung“

## Beispiel
```dart
final registry = await ref.read(collectionRegistryProvider.future);
final isValid = registry.isValid(123456789);
```

## Nächste Schritte
- Implementierung von Service und Provider
- Tests und Doku

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_collectionid_refactoring.md` (siehe auch Altprojekt).
