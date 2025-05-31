// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureFlagsImpl _$$FeatureFlagsImplFromJson(Map<String, dynamic> json) =>
    _$FeatureFlagsImpl(
      showPortfolioTab: json['showPortfolioTab'] as bool?,
      enableContactForm: json['enableContactForm'] as bool?,
      showPodcastGenre: json['showPodcastGenre'] as bool?,
      customStartTab: json['customStartTab'] as String?,
    );

Map<String, dynamic> _$$FeatureFlagsImplToJson(_$FeatureFlagsImpl instance) =>
    <String, dynamic>{
      'showPortfolioTab': instance.showPortfolioTab,
      'enableContactForm': instance.enableContactForm,
      'showPodcastGenre': instance.showPodcastGenre,
      'customStartTab': instance.customStartTab,
    };
