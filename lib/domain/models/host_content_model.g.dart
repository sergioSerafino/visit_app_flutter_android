// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostContentImpl _$$HostContentImplFromJson(Map<String, dynamic> json) =>
    _$HostContentImpl(
      bio: json['bio'] as String?,
      mission: json['mission'] as String?,
      rss: json['rss'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HostContentImplToJson(_$HostContentImpl instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'mission': instance.mission,
      'rss': instance.rss,
      'links': instance.links,
    };
