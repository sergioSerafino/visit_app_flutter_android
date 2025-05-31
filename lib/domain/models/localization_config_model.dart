// \lib\domain\models\localization_config_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
part 'localization_config_model.freezed.dart';
part 'localization_config_model.g.dart';

@freezed
class LocalizationConfig with _$LocalizationConfig {
  const factory LocalizationConfig({
    String? defaultLanguageCode, // aus RSS oder JSON
    Map<String, String>? localizedTexts, // z. B. Buttonlabels, Begrüßung etc.
  }) = _LocalizationConfig;

  factory LocalizationConfig.fromJson(Map<String, dynamic> json) =>
      _$LocalizationConfigFromJson(json);

  static LocalizationConfig empty() {
    return const LocalizationConfig(
        defaultLanguageCode: "en", localizedTexts: {});
  }
}
