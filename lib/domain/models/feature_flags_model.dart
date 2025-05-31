// \lib\domain\models\feature_flags_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flags_model.freezed.dart';
part 'feature_flags_model.g.dart';

@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    bool? showPortfolioTab,
    bool? enableContactForm,
    bool? showPodcastGenre,
    String? customStartTab, // "episodes", "home", ...
  }) = _FeatureFlags;

  factory FeatureFlags.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsFromJson(json);

  static FeatureFlags empty() {
    return const FeatureFlags(
      showPortfolioTab: false,
      enableContactForm: false,
      showPodcastGenre: false,
      customStartTab: "home",
    );
  }
}
