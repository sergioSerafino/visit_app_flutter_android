<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_collection_registry.md -->

# Schritt 1: Refactoring CollectionId-Provider & Caching

## Ziel
- Persistente Speicherung und Verwaltung der aktiven CollectionId über einen eigenen Service (Hive-basiert)
- Kapselung der CollectionId-Logik in einen StateNotifierProvider
- Automatisches Branding-Update bei CollectionId-Wechsel
- Grundlage für weitere Refactoring-Schritte (Registry, Validierung, TTL, etc.)

## Umsetzung
- Neuer Service: `CollectionIdStorage` (Hive, Key: 'activeCollectionId')
- Neuer Provider: `collectionIdProvider` (StateNotifierProvider, lädt/speichert CollectionId persistent)
- Listener für CollectionId-Wechsel aktualisiert Branding automatisch
- Bestehende Provider und Branding-Update-Logik bleiben erhalten, werden aber auf neuen Provider umgestellt

## Architektur-Entscheidung
- Trennung von UI-State und Persistenz
- Testbarkeit: CollectionId kann im Test gezielt gesetzt und geprüft werden
- Grundlage für Registry/Validierung/TTL in weiteren Schritten

## Beispiel
```dart
final collectionIdProvider = StateNotifierProvider<CollectionIdNotifier, int>((ref) {
  final storage = ref.watch(collectionIdStorageProvider);
  return CollectionIdNotifier(storage);
});

class CollectionIdNotifier extends StateNotifier<int> {
  final CollectionIdStorage storage;
  CollectionIdNotifier(this.storage) : super(1814331727) {
    _load();
  }
  // ...
}
```

## Nächste Schritte
- Umstellung aller Stellen im Code auf den neuen Provider
- Erweiterung um Registry, Validierung, TTL-Cache, Fallback etc. (siehe Roadmap)

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_collection_registry.md` (siehe auch Altprojekt).
