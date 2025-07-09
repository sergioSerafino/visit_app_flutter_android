import 'package:hive/hive.dart';

part 'podcast_hive_adapter.g.dart';

@HiveType(typeId: 11)
class HivePodcast extends HiveObject {
  @HiveField(0)
  String wrapperType;
  @HiveField(1)
  int collectionId;
  @HiveField(2)
  String collectionName;
  @HiveField(3)
  String artistName;
  @HiveField(4)
  String primaryGenreName;
  @HiveField(5)
  String artworkUrl600;
  @HiveField(6)
  String? feedUrl;

  HivePodcast({
    required this.wrapperType,
    required this.collectionId,
    required this.collectionName,
    required this.artistName,
    required this.primaryGenreName,
    required this.artworkUrl600,
    this.feedUrl,
  });
}
