// lib/application/providers/collection_provider.dart
// - collectionIdStateProvider - Was ist die aktive Collection

// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Collection-Provider, Persistenz und Teststrategie.
// Lessons Learned: Persistente CollectionId, StateNotifier-Pattern und Hive-Integration für flexible, testbare Collection-Auswahl. Siehe auch collection_id_storage.dart.
// Hinweise: Default-IDs, Testdaten und Persistenz beachten.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/collection_load_state.dart';
import '../controllers/collection_load_controller.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/host_model.dart';
import '../../core/placeholders/placeholder_content.dart';
import 'package:hive/hive.dart';
import '../../core/services/collection_id_storage.dart';
import '../../config/tenant_loader_service.dart';

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

final brandingProvider = StateProvider<Branding>(
  (ref) => PlaceholderContent.hostModel.branding,
);

/// Provider für das aktuell geladene HostModel (dynamisch, mit Fallback)
final hostModelProvider = StateProvider<Host>(
  (ref) => PlaceholderContent.hostModel,
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

void updateHostModelOnCollectionChange(
    WidgetRef ref, int newCollectionId) async {
  final box = await Hive.openBox('hostInfoBox');
  final hostModel = box.get(newCollectionId.toString());
  if (hostModel != null) {
    ref.read(hostModelProvider.notifier).state = hostModel;
  } else {
    ref.read(hostModelProvider.notifier).state = PlaceholderContent.hostModel;
  }
}

/*
// Vorbereitung für SnackBar-Integration
// Du kannst bei .setError() (oder .loadCollection() etc.) künftig direkt SnackBarEvent dispatchen:

ref.read(snackbarManagerProvider).showByKey('host_data_fetch_failed');

*/

// Listener für Collection-Wechsel (z. B. im main() oder in einem Initializer-Widget aufrufen)
void listenToCollectionIdChanges(WidgetRef ref) {
  ref.listen<int>(collectionIdProvider, (previous, next) async {
    if (previous != next) {
      // Dynamisches Branding-Update bei CollectionId-Wechsel
      try {
        final host = await TenantLoaderService.loadHostModel(next.toString());
        ref.read(brandingProvider.notifier).state = host.branding;
        ref.read(hostModelProvider.notifier).state = host;
      } catch (e) {
        // Fallback auf Placeholder-Branding und HostModel
        ref.read(brandingProvider.notifier).state =
            PlaceholderContent.hostModel.branding;
        ref.read(hostModelProvider.notifier).state =
            PlaceholderContent.hostModel;
      }
    }
  });
}

/// Dokumentation:
/// Diese Funktion sollte beim App-Start (z. B. in main.dart oder app.dart) einmalig aufgerufen werden.
/// Sie sorgt dafür, dass bei jeder Änderung der CollectionId das passende Branding geladen und gesetzt wird.
/// Das Branding wird aus der jeweiligen host_model.json geladen (mit Fallback auf common/placeholder).
