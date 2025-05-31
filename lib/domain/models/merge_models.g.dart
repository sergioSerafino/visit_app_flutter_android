// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merge_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItunesDataImpl _$$ItunesDataImplFromJson(Map<String, dynamic> json) =>
    _$ItunesDataImpl(
      collectionId: (json['collectionId'] as num?)?.toInt(),
      trackName: json['trackName'] as String?,
      shortDescription: json['shortDescription'] as String?,
      artworkUrl600: json['artworkUrl600'] as String?,
      artistName: json['artistName'] as String?,
      feedUrl: json['feedUrl'] as String?,
    );

Map<String, dynamic> _$$ItunesDataImplToJson(_$ItunesDataImpl instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'trackName': instance.trackName,
      'shortDescription': instance.shortDescription,
      'artworkUrl600': instance.artworkUrl600,
      'artistName': instance.artistName,
      'feedUrl': instance.feedUrl,
    };

_$RssDataImpl _$$RssDataImplFromJson(Map<String, dynamic> json) =>
    _$RssDataImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] as String?,
      ownerEmail: json['ownerEmail'] as String?,
    );

Map<String, dynamic> _$$RssDataImplToJson(_$RssDataImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'author': instance.author,
      'ownerEmail': instance.ownerEmail,
    };

_$LocalJsonDataImpl _$$LocalJsonDataImplFromJson(Map<String, dynamic> json) =>
    _$LocalJsonDataImpl(
      collectionId: (json['collectionId'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] as String?,
      contactEmail: json['contactEmail'] as String?,
      authTokenRequired: json['authTokenRequired'] as bool?,
      featureFlags: (json['featureFlags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$LocalJsonDataImplToJson(_$LocalJsonDataImpl instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'author': instance.author,
      'contactEmail': instance.contactEmail,
      'authTokenRequired': instance.authTokenRequired,
      'featureFlags': instance.featureFlags,
    };

_$PodcastHostCollectionImpl _$$PodcastHostCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PodcastHostCollectionImpl(
      collectionId: (json['collectionId'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      author: json['author'] as String?,
      contactEmail: json['contactEmail'] as String?,
      authTokenRequired: json['authTokenRequired'] as bool?,
      isManagedCollection: json['isManagedCollection'] as bool?,
      featureFlags: (json['featureFlags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$PodcastHostCollectionImplToJson(
        _$PodcastHostCollectionImpl instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'title': instance.title,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'author': instance.author,
      'contactEmail': instance.contactEmail,
      'authTokenRequired': instance.authTokenRequired,
      'isManagedCollection': instance.isManagedCollection,
      'featureFlags': instance.featureFlags,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
