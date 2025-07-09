import 'package:hive/hive.dart';

part 'collection_meta_hive_adapter.g.dart';

@HiveType(typeId: 26)
class HiveCollectionMeta extends HiveObject {
  @HiveField(0)
  String? source;
  @HiveField(1)
  String? version;
  @HiveField(2)
  DateTime? lastSynced;

  HiveCollectionMeta({
    this.source,
    this.version,
    this.lastSynced,
  });
}
