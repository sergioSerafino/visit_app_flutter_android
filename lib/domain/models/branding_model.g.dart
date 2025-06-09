// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandingImpl _$$BrandingImplFromJson(Map<String, dynamic> json) =>
    _$BrandingImpl(
      primaryColorHex: json['primaryColorHex'] as String?,
      secondaryColorHex: json['secondaryColorHex'] as String?,
      headerImageUrl: json['headerImageUrl'] as String?,
      themeMode: json['themeMode'] as String?,
      logoUrl: json['logoUrl'] as String?,
      assetLogo: json['assetLogo'] as String?,
    );

Map<String, dynamic> _$$BrandingImplToJson(_$BrandingImpl instance) =>
    <String, dynamic>{
      'primaryColorHex': instance.primaryColorHex,
      'secondaryColorHex': instance.secondaryColorHex,
      'headerImageUrl': instance.headerImageUrl,
      'themeMode': instance.themeMode,
      'logoUrl': instance.logoUrl,
      'assetLogo': instance.assetLogo,
    };
