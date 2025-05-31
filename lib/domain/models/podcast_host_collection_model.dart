//  lib/domain/models/podcast_host_collection_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'collection_meta_model.dart';
import '/../../domain/models/host_model.dart';
import '/../../domain/models/podcast_episode_model.dart';
import '/../../domain/models/podcast_model.dart';

part 'podcast_host_collection_model.freezed.dart';
part 'podcast_host_collection_model.g.dart';

@freezed
class PodcastHostCollection with _$PodcastHostCollection {
  const factory PodcastHostCollection({
    required int collectionId,
    required Podcast podcast,
    required List<PodcastEpisode> episodes,
    Host? host,
    DateTime? downloadedAt,
    required CollectionMeta meta,
  }) = _PodcastHostCollection;

  factory PodcastHostCollection.fromJson(Map<String, dynamic> json) =>
      _$PodcastHostCollectionFromJson(json);
}
