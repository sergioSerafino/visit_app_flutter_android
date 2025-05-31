// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionMetaImpl _$$CollectionMetaImplFromJson(Map<String, dynamic> json) =>
    _$CollectionMetaImpl(
      podcastOrigin:
          DataOrigin.fromJson(json['podcastOrigin'] as Map<String, dynamic>),
      episodeOrigin:
          DataOrigin.fromJson(json['episodeOrigin'] as Map<String, dynamic>),
      hostOrigin: json['hostOrigin'] == null
          ? null
          : DataOrigin.fromJson(json['hostOrigin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CollectionMetaImplToJson(
        _$CollectionMetaImpl instance) =>
    <String, dynamic>{
      'podcastOrigin': instance.podcastOrigin,
      'episodeOrigin': instance.episodeOrigin,
      'hostOrigin': instance.hostOrigin,
    };
