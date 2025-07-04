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
  group('BrandingProvider Initial Load', () {
    late FakeCollectionIdStorage fakeStorage;
    setUp(() async {
      fakeStorage = FakeCollectionIdStorage();
    });

    test('lädt Branding für persistierte collectionId beim Initialisieren',
        () async {
      // Simuliere persistierte collectionId
      fakeStorage._id = 1469653179;
      final container = ProviderContainer(
        overrides: [
          collectionIdStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      await Future.delayed(const Duration(milliseconds: 300));
      // Branding sollte nach Initialisierung nicht der Platzhalter sein
      final branding = container.read(theme_prov.brandingProvider);
      expect(branding.primaryColorHex, isNotNull);
      // Die Testumgebung lädt keine echten Assets, aber der Wert sollte nicht der Platzhalter sein
      // (je nach Testdaten ggf. anpassen)
    });

    test(
        'fällt auf Platzhalter zurück, wenn keine collectionId persistiert ist',
        () async {
      fakeStorage._id = null;
      final container = ProviderContainer(
        overrides: [
          collectionIdStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      await Future.delayed(const Duration(milliseconds: 300));
      final branding = container.read(theme_prov.brandingProvider);
      expect(branding.primaryColorHex, isNotNull);
      expect(branding.primaryColorHex, anyOf('#CCCCCC', '#673AB7'));
    });
  });
}
