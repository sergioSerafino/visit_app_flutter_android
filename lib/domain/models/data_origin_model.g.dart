// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_origin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DataOriginImpl _$$DataOriginImplFromJson(Map<String, dynamic> json) =>
    _$DataOriginImpl(
      source: $enumDecode(_$DataSourceTypeEnumMap, json['source']),
      updatedAt: json['updatedAt'] as String,
      isFallback: json['isFallback'] as bool,
    );

Map<String, dynamic> _$$DataOriginImplToJson(_$DataOriginImpl instance) =>
    <String, dynamic>{
      'source': _$DataSourceTypeEnumMap[instance.source]!,
      'updatedAt': instance.updatedAt,
      'isFallback': instance.isFallback,
    };

const _$DataSourceTypeEnumMap = {
  DataSourceType.itunes: 'itunes',
  DataSourceType.rss: 'rss',
  DataSourceType.json: 'json',
  DataSourceType.local: 'local',
};
