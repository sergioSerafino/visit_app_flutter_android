// lib/application/providers/collection_provider.dart
// - collectionIdStateProvider - Was ist die aktive Collection

// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Collection-Provider, Persistenz und Teststrategie.
// Lessons Learned: Persistente CollectionId, StateNotifier-Pattern und Hive-Integration für flexible, testbare Collection-Auswahl. Siehe auch collection_id_storage.dart.
// Hinweise: Default-IDs, Testdaten und Persistenz beachten.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/collection_load_state.dart';
import '../controllers/collection_load_controller.dart';
import '../../core/placeholders/placeholder_content.dart';
import '../../core/services/collection_id_storage.dart';
import '../../domain/models/host_model.dart';

final hostModelProvider = StateProvider<Host>(
  (ref) => PlaceholderContent.hostModel,
);

final collectionIdStorageProvider = Provider<CollectionIdStorage>(
  (ref) => CollectionIdStorage(),
);

/// Aktive Collection-ID (persistiert in Hive, Default: 1814331727)
final collectionIdProvider = StateNotifierProvider<CollectionIdNotifier, int>((
  ref,
) {
  final storage = ref.watch(collectionIdStorageProvider);
  return CollectionIdNotifier(storage);
});

class CollectionIdNotifier extends StateNotifier<int> {
  final CollectionIdStorage storage;
  // Beispiele für Default-CollectionIds:
  // 1814331727, 1590516386, 1469653179, 1481054140, 1765742605, 9876543210
  CollectionIdNotifier(this.storage) : super(1590516386) {
    _load(); // Deaktiviert für harten Testwert
  }

  Future<void> _load() async {
    final loaded = await storage.load();
    if (loaded != null) state = loaded;
  }

  Future<void> load() async {
    final loaded = await storage.load();
    if (loaded != null) state = loaded;
  }

  Future<void> setCollectionId(int newId) async {
    state = newId;
    await storage.save(newId);
  }
}

/// Controller zur Steuerung des Collection-Ladestatus
final collectionLoadControllerProvider =
    StateNotifierProvider<CollectionLoadController, CollectionLoadState>(
  (ref) => CollectionLoadController(ref),
);

/*
// Vorbereitung für SnackBar-Integration
// Du kannst bei .setError() (oder .loadCollection() etc.) künftig direkt SnackBarEvent dispatchen:

ref.read(snackbarManagerProvider).showByKey('host_data_fetch_failed');

*/

/// Dokumentation:
/// Diese Funktion sollte beim App-Start (z. B. in main.dart oder app.dart) einmalig aufgerufen werden.
/// Sie sorgt dafür, dass bei jeder Änderung der CollectionId das passende Branding geladen und gesetzt wird.
/// Das Branding wird aus der jeweiligen host_model.json geladen (mit Fallback auf common/placeholder).
