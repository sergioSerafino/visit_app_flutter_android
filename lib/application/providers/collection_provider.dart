// lib/application/providers/collection_provider.dart
// - collectionIdStateProvider - Was ist die aktive Collection

// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Collection-Provider, Persistenz und Teststrategie.
// Lessons Learned: Persistente CollectionId, StateNotifier-Pattern und Hive-Integration für flexible, testbare Collection-Auswahl. Siehe auch collection_id_storage.dart.
// Hinweise: Default-IDs, Testdaten und Persistenz beachten.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/collection_load_state.dart';
import '../controllers/collection_load_controller.dart';
import '../../domain/models/branding_model.dart';
import '../../core/placeholders/placeholder_content.dart';
import 'package:hive/hive.dart';
import '../../core/services/collection_id_storage.dart';

//1469653179 Shayan & Nizar
//1765742605 Fest und Flauschig
//1481054140 barbaradio
//1292709842
//1590516386 Opalia Talk
//1191610678 Curse
//1814331727 Fullcourt Attitude

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
  CollectionIdNotifier(this.storage) : super(1814331727) {
    _load();
  }

  Future<void> _load() async {
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

final brandingProvider = StateProvider<Branding>(
  (ref) => PlaceholderContent.hostModel.branding,
);

void updateBrandingOnCollectionChange(dynamic ref, int newCollectionId) async {
  // Versuche Branding aus Hive zu laden
  final box = await Hive.openBox('hostInfoBox');
  final hostModel = box.get(newCollectionId.toString());
  if (hostModel != null && hostModel.branding != null) {
    ref.read(brandingProvider.notifier).state = hostModel.branding;
  } else {
    ref.read(brandingProvider.notifier).state =
        PlaceholderContent.hostModel.branding;
  }
}

/*
// Vorbereitung für SnackBar-Integration
// Du kannst bei .setError() (oder .loadCollection() etc.) künftig direkt SnackBarEvent dispatchen:

ref.read(snackbarManagerProvider).showByKey('host_data_fetch_failed');

*/

// Listener für Collection-Wechsel (z. B. im main() oder in einem Initializer-Widget aufrufen)
void listenToCollectionIdChanges(WidgetRef ref) {
  ref.listen<int>(collectionIdProvider, (previous, next) {
    if (previous != next) {
      updateBrandingOnCollectionChange(ref, next);
    }
  });
}
