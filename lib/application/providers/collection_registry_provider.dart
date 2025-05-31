// filepath: lib/application/providers/collection_registry_provider.dart
// AsyncNotifier für CollectionRegistry, prüft Gültigkeit von CollectionIds

// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu CollectionRegistry, Validierung und Teststrategie.
// Lessons Learned: collectionRegistryProvider und collectionIdValidatorProvider kapseln das Laden und Validieren von CollectionIds. Besonderheiten: AsyncNotifier für asynchrone Logik, testbare Validierung, zentrale Registry. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt einfache Erweiterung um weitere Registry-Quellen und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/services/collection_registry_service.dart';

final collectionRegistryServiceProvider = Provider(
  (ref) => CollectionRegistryService(
    dio: Dio(),
    remoteUrl:
        'https://example.com/collection_registry.json', // TODO: echte URL eintragen
  ),
);

final collectionRegistryProvider = FutureProvider<List<int>>((ref) async {
  final service = ref.watch(collectionRegistryServiceProvider);
  return await service.getRegistry();
});

final collectionIdValidatorProvider = FutureProvider.family<bool, int>(
  (
    ref,
    collectionId,
  ) async {
    final service = ref.watch(collectionRegistryServiceProvider);
    return await service.isValid(collectionId);
  },
);
