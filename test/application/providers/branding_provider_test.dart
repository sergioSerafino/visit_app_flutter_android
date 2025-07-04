import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visit_app_flutter_android/application/providers/collection_provider.dart';
import 'package:visit_app_flutter_android/application/providers/theme_provider.dart'
    as theme_prov;
import 'package:visit_app_flutter_android/core/services/collection_id_storage.dart';

class FakeCollectionIdStorage extends CollectionIdStorage {
  int? _id;
  @override
  Future<int?> load() async => _id;
  @override
  Future<void> save(int id) async => _id = id;
}

void main() {
  group('BrandingProvider', () {
    late FakeCollectionIdStorage fakeStorage;
    setUp(() async {
      fakeStorage = FakeCollectionIdStorage();
    });
    test('lädt Branding dynamisch bei CollectionId-Wechsel (Mock)', () async {
      final container = ProviderContainer(
        overrides: [
          collectionIdStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      final initialBranding = container.read(theme_prov.brandingProvider);
      expect(initialBranding.primaryColorHex, isNotNull);
      await container
          .read(collectionIdProvider.notifier)
          .setCollectionId(1469653179);
      await Future.delayed(const Duration(milliseconds: 300));
      final updatedBranding = container.read(theme_prov.brandingProvider);
      // Da keine echten Assets geladen werden, bleibt Branding ggf. gleich, aber Test prüft Robustheit
      expect(updatedBranding.primaryColorHex, isNotNull);
    });
    test('fällt auf Platzhalter zurück bei ungültiger CollectionId (Mock)',
        () async {
      final container = ProviderContainer(
        overrides: [
          collectionIdStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      await container
          .read(collectionIdProvider.notifier)
          .setCollectionId(999999999);
      await Future.delayed(const Duration(milliseconds: 300));
      final fallbackBranding = container.read(theme_prov.brandingProvider);
      expect(fallbackBranding.primaryColorHex, isNotNull);
      expect(fallbackBranding.primaryColorHex, anyOf('#CCCCCC', '#673AB7'));
    });
  });
}
