// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PodcastCollectionImpl _$$PodcastCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PodcastCollectionImpl(
      podcasts: (json['podcasts'] as List<dynamic>)
          .map((e) => Podcast.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadedAt: json['downloadedAt'] == null
          ? null
          : DateTime.parse(json['downloadedAt'] as String),
    );
