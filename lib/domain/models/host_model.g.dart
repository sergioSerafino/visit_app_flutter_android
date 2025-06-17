// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostImpl _$$HostImplFromJson(Map<String, dynamic> json) => _$HostImpl(
      collectionId: (json['collectionId'] as num).toInt(),
      hostName: json['hostName'] as String,
      description: json['description'] as String,
      contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
      branding: Branding.fromJson(json['branding'] as Map<String, dynamic>),
      features: FeatureFlags.fromJson(json['features'] as Map<String, dynamic>),
      localization: LocalizationConfig.fromJson(
          json['localization'] as Map<String, dynamic>),
      content: HostContent.fromJson(json['content'] as Map<String, dynamic>),
      primaryGenreName: json['primaryGenreName'] as String?,
      authTokenRequired: json['authTokenRequired'] as bool? ?? false,
      debugOnly: json['debugOnly'] as bool?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      hostImage: json['hostImage'] as String?,
    );

Map<String, dynamic> _$$HostImplToJson(_$HostImpl instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'hostName': instance.hostName,
      'description': instance.description,
      'contact': instance.contact,
      'branding': instance.branding,
      'features': instance.features,
      'localization': instance.localization,
      'content': instance.content,
      'primaryGenreName': instance.primaryGenreName,
      'authTokenRequired': instance.authTokenRequired,
      'debugOnly': instance.debugOnly,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'hostImage': instance.hostImage,
    };
