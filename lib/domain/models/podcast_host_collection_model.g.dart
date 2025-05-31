// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_host_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PodcastHostCollectionImpl _$$PodcastHostCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PodcastHostCollectionImpl(
      collectionId: (json['collectionId'] as num).toInt(),
      podcast: Podcast.fromJson(json['podcast'] as Map<String, dynamic>),
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => PodcastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
      host: json['host'] == null
          ? null
          : Host.fromJson(json['host'] as Map<String, dynamic>),
      downloadedAt: json['downloadedAt'] == null
          ? null
          : DateTime.parse(json['downloadedAt'] as String),
      meta: CollectionMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PodcastHostCollectionImplToJson(
        _$PodcastHostCollectionImpl instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'podcast': instance.podcast,
      'episodes': instance.episodes,
      'host': instance.host,
      'downloadedAt': instance.downloadedAt?.toIso8601String(),
      'meta': instance.meta,
    };
