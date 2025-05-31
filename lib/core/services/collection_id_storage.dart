// Hive-basierter Storage für die aktive CollectionId
import 'package:hive/hive.dart';

class CollectionIdStorage {
  static const String _boxName = 'app_settings';
  static const String _key = 'activeCollectionId';

  Future<int?> load() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_key) as int?;
  }

  Future<void> save(int collectionId) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, collectionId);
  }
}
