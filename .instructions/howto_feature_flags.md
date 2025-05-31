<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_merge_caching.md, adr-001-merge-strategy.md, architecture_clean_architecture.md -->

# Schritt 3: Messaging/Snackbar, FeatureFlags, Teststrategie

## Ziel
- Messaging/Snackbar-Logik als StateNotifier/Provider vereinheitlichen und testbar machen
- FeatureFlags-Provider mit Caching und Fallback
- Teststrategie für Messaging und FeatureFlags

## Umsetzung
- SnackbarManager ist bereits als StateNotifierProvider implementiert
- Events werden per showByKey(key) ausgelöst, YAML-Konfiguration wird geladen
- FeatureFlags werden aktuell aus LocalJson/RSS/iTunes gemergt, aber nicht separat gecacht oder als Provider gekapselt

## ToDos für Schritt 3
- [x] SnackbarManager-Architektur dokumentieren (siehe unten)
- [ ] FeatureFlagsProvider als StateNotifierProvider mit Caching (Hive, TTL)
- [ ] Tests für FeatureFlagsProvider und Messaging/SnackbarManager
- [ ] Doku-Update in architecture.md und Teststrategie

## Architektur-Entscheidung
- Messaging/Snackbar: StateNotifierProvider, YAML-Konfiguration, Factory für Events, Queue/State-Reset für wiederholte Events
- FeatureFlags: Provider mit Caching, Fallback, testbar und lose gekoppelt

## Beispiel SnackbarManager
```dart
final snackbarManagerProvider = StateNotifierProvider<SnackbarManager, SnackbarEvent?>((ref) {
  return SnackbarManager(ref);
});

snackbarManager.showByKey('host_data_fetch_failed');
```

# Teststrategie & Provider-Mocking (Mai 2025)

## Asynchrone Provider-Initialisierung & Mocking

- Viele Provider (z.B. FeatureFlagsProvider, PagingProvider) laden ihren State asynchron im Konstruktor (z.B. per _load()).
- Im Test muss auf die State-Änderung gewartet werden, bevor geprüft wird. Andernfalls ist der State noch im Initialzustand (z.B. .empty()).
- **Pattern:**
  - ProviderContainer mit passenden Overrides für alle abhängigen Provider (z.B. Storage, Cache, CollectionId).
  - Für StateNotifierProvider, die asynchron initialisieren, im Test mit `container.listen` auf State-Änderung warten oder einen kurzen Delay (`await Future.delayed(...)`) einbauen.
  - Beispiel für FeatureFlagsProvider:

```dart
final container = ProviderContainer(
  overrides: [
    featureFlagsCacheServiceProvider.overrideWithValue(fakeCache),
    collectionIdStorageProvider.overrideWithValue(testStorage),
    collectionIdProvider.overrideWith((ref) => TestCollectionIdNotifier(testStorage)),
  ],
);
await Future.delayed(Duration(milliseconds: 100));
final flags = container.read(featureFlagsProvider);
expect(flags.showPortfolioTab, true);
```

- **Wichtig:**
  - TestCollectionIdStorage implementiert CollectionIdStorage, damit keine echten Hive-Zugriffe erfolgen.
  - TestCollectionIdNotifier setzt einen festen State, damit der Test deterministisch bleibt.
  - Für komplexere Fälle empfiehlt sich ein `Completer` und ein Listener auf den Provider-State.

## Übertrag auf weitere Provider
- Dieses Pattern kann für alle Provider verwendet werden, die asynchron initialisieren oder externe Abhängigkeiten (Hive, Netzwerk) haben.
- Siehe auch Testfälle für PagingProvider, MergeService etc.

## Nächste Schritte
- FeatureFlagsProvider implementieren (StateNotifier, Hive, TTL, Fallback)
- Tests für Messaging und FeatureFlags
- Doku-Update

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_merge_caching.md`, `adr-001-merge-strategy.md`, `architecture_clean_architecture.md` (siehe auch Altprojekt).
