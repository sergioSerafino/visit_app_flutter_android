import 'package:hive/hive.dart';

part 'podcast_episode_hive_adapter.g.dart';

@HiveType(typeId: 12)
class HivePodcastEpisode extends HiveObject {
  @HiveField(0)
  String wrapperType;
  @HiveField(1)
  int trackId;
  @HiveField(2)
  String trackName;
  @HiveField(3)
  String artworkUrl600;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String episodeUrl;
  @HiveField(6)
  int trackTimeMillis;
  @HiveField(7)
  String episodeFileExtension;
  @HiveField(8)
  DateTime releaseDate;
  @HiveField(9)
  DateTime? downloadedAt;
  @HiveField(10)
  String? localId;

  HivePodcastEpisode({
    required this.wrapperType,
    required this.trackId,
    required this.trackName,
    required this.artworkUrl600,
    this.description,
    required this.episodeUrl,
    required this.trackTimeMillis,
    required this.episodeFileExtension,
    required this.releaseDate,
    this.downloadedAt,
    this.localId,
  });
}
