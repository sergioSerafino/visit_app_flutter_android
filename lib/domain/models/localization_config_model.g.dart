// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalizationConfigImpl _$$LocalizationConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalizationConfigImpl(
      defaultLanguageCode: json['defaultLanguageCode'] as String?,
      localizedTexts: (json['localizedTexts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$LocalizationConfigImplToJson(
        _$LocalizationConfigImpl instance) =>
    <String, dynamic>{
      'defaultLanguageCode': instance.defaultLanguageCode,
      'localizedTexts': instance.localizedTexts,
    };
