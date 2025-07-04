import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:visit_app_flutter_android/application/providers/collection_provider.dart';

void main() {
  group('collectionIdProvider', () {
    late ProviderContainer container;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
      container = ProviderContainer();
    });

    tearDown(() async {
      // Relevante Hive-Boxen schließen und löschen, um Zugriffskonflikte zu vermeiden
      try {
        var box = await Hive.openBox('app_settings');
        await box.close();
        await Hive.deleteBoxFromDisk('app_settings');
      } catch (_) {}
      try {
        var box = await Hive.openBox('hostInfoBox');
        await box.close();
        await Hive.deleteBoxFromDisk('hostInfoBox');
      } catch (_) {}
      container.dispose();
      await tempDir.delete(recursive: true);
    });

    test('ändert Wert korrekt bei CollectionId-Wechsel', () async {
      // Arrange
      const testCollectionId = 123456789;
      // Act
      await container
          .read(collectionIdProvider.notifier)
          .setCollectionId(testCollectionId);
      // Assert
      expect(container.read(collectionIdProvider), testCollectionId);
    });
  });
}
