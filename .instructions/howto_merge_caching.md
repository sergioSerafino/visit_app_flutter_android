<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_merge_decisions_and_field_sources.md, adr-001-merge-strategy.md, howto_feature_flags.md -->

# Schritt 2: MergeService, Datenquellen & Caching/Offline

## Ziel
- Kapselung und Priorisierung der Datenquellen (iTunes, RSS, Local JSON) im MergeService
- Persistenter Cache für gemergte PodcastHostCollection-Objekte (Hive, TTL)
- Offline- und Fallback-Strategie: Bei Fehlern/Offline wird letzte gültige Kopie aus Hive verwendet
- Testbarkeit und Layer-Trennung weiter erhöhen

## Umsetzung
- Neuer Service: `MergedCollectionCacheService` (Hive, TTL, Save/Load/Invalidate)
- MergeService prüft vor dem Mergen, ob ein frischer Cache existiert, und nutzt diesen
- Nach erfolgreichem Merge wird das Ergebnis im Cache gespeichert
- Konstruktor von MergeService um CacheService erweitert
- Grundlage für weitere Schritte (z. B. Registry, FeatureFlags, Messaging)

## Architektur-Entscheidung
- Trennung von Merge-Logik und Cache-Strategie
- Testbarkeit: CacheService kann gemockt werden
- Grundlage für Offline- und Fallback-Strategien

## Beispiel
```dart
final merged = await mergeService.merge(collectionId);
// Holt aus Cache, wenn frisch, sonst mergen und speichern
```

## Nächste Schritte
- Erweiterung der Tests für Cache-Strategie und Fallback
- Umstellung aller Aufrufer auf den neuen MergeService-Konstruktor
- Dokumentation in architecture.md und MergeService-Doku

# Teststrategie: Fallback/Placeholder & Mocking (Mai 2025)

- Für MergeService gilt das gleiche Testpattern wie für FeatureFlags und Paging:
  - ProviderContainer (bzw. Service-Setup) mit passenden Mocks für alle Datenquellen (API, RSS, LocalJson, Cache).
  - Asynchrone Initialisierung beachten: Im Test ggf. auf Future warten oder State-Änderung abwarten.
  - Mock-Implementierungen für alle Datenquellen, um alle Fallback-Ketten (Cache, API, RSS, LocalJson, Placeholder) zu testen.
- Testfälle:
  - Cache frisch → Daten aus Cache
  - Cache abgelaufen/leer → Merge aus Datenquellen, dann speichern
  - API/RSS/LocalJson nicht erreichbar → Fallback auf Cache/Placeholder
  - Feld-Priorisierung und Merge-Entscheidungen explizit testen (siehe merge_service_unit_test.dart)
- Siehe auch Testfälle in `test/core/services/merge_service_unit_test.dart` und `test/core/services/merge_service_test.dart`.
- Pattern ist für alle komplexen Merge-/Datenservices wiederverwendbar.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_merge_decisions_and_field_sources.md`, `adr-001-merge-strategy.md`, `howto_feature_flags.md` (siehe auch Altprojekt).
