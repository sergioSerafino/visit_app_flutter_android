// Hive-Adapter für PodcastHostCollection und verschachtelte Modelle
// Siehe .documents/datenpersistenz_architektur_vorgehen.md und .documents/datenpersistenz_provider_abrufanalyse.md

import 'package:hive/hive.dart';

import 'podcast_hive_adapter.dart';
import 'podcast_episode_hive_adapter.dart';
import 'host_hive_adapter.dart';
import 'collection_meta_hive_adapter.dart';

part 'podcast_host_collection_hive_adapter.g.dart';

@HiveType(typeId: 10)
class HivePodcastHostCollection extends HiveObject {
  @HiveField(0)
  int collectionId;

  @HiveField(1)
  HivePodcast podcast;

  @HiveField(2)
  List<HivePodcastEpisode> episodes;

  @HiveField(3)
  HiveHost? host;

  @HiveField(4)
  DateTime? downloadedAt;

  @HiveField(5)
  HiveCollectionMeta meta;

  HivePodcastHostCollection({
    required this.collectionId,
    required this.podcast,
    required this.episodes,
    this.host,
    this.downloadedAt,
    required this.meta,
  });
}

// Die verschachtelten Hive-Modelle (HivePodcast, HivePodcastEpisode, HiveHost, HiveCollectionMeta)
// müssen analog mit eigenen TypeIds und Feldern angelegt werden.
// Die Konvertierung zwischen Freezed-Modell und Hive-Modell erfolgt über Mapper-Methoden.
