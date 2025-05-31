// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      email: json['email'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      impressumUrl: json['impressumUrl'] as String?,
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'websiteUrl': instance.websiteUrl,
      'impressumUrl': instance.impressumUrl,
      'socialLinks': instance.socialLinks,
    };
