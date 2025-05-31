// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PodcastImpl _$$PodcastImplFromJson(Map<String, dynamic> json) =>
    _$PodcastImpl(
      wrapperType: json['wrapperType'] as String,
      collectionId: (json['collectionId'] as num).toInt(),
      collectionName: json['collectionName'] as String,
      artistName: json['artistName'] as String,
      primaryGenreName: json['primaryGenreName'] as String,
      artworkUrl600: json['artworkUrl600'] as String,
      feedUrl: json['feedUrl'] as String?,
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => PodcastEpisode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PodcastImplToJson(_$PodcastImpl instance) =>
    <String, dynamic>{
      'wrapperType': instance.wrapperType,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'artistName': instance.artistName,
      'primaryGenreName': instance.primaryGenreName,
      'artworkUrl600': instance.artworkUrl600,
      'feedUrl': instance.feedUrl,
      'episodes': instance.episodes,
    };
