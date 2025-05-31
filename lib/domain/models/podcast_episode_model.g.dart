// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PodcastEpisodeImpl _$$PodcastEpisodeImplFromJson(Map<String, dynamic> json) =>
    _$PodcastEpisodeImpl(
      wrapperType: json['wrapperType'] as String,
      trackId: (json['trackId'] as num).toInt(),
      trackName: json['trackName'] as String,
      artworkUrl600: json['artworkUrl600'] as String,
      description: json['description'] as String?,
      episodeUrl: json['episodeUrl'] as String,
      trackTimeMillis: (json['trackTimeMillis'] as num).toInt(),
      episodeFileExtension: json['episodeFileExtension'] as String,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
    );

Map<String, dynamic> _$$PodcastEpisodeImplToJson(
        _$PodcastEpisodeImpl instance) =>
    <String, dynamic>{
      'wrapperType': instance.wrapperType,
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'artworkUrl600': instance.artworkUrl600,
      'description': instance.description,
      'episodeUrl': instance.episodeUrl,
      'trackTimeMillis': instance.trackTimeMillis,
      'episodeFileExtension': instance.episodeFileExtension,
      'releaseDate': instance.releaseDate.toIso8601String(),
    };
