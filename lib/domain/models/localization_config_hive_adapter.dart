import 'package:hive/hive.dart';

part 'localization_config_hive_adapter.g.dart';

@HiveType(typeId: 23)
class HiveLocalizationConfig extends HiveObject {
  @HiveField(0)
  String? defaultLanguageCode;
  @HiveField(1)
  Map<String, String>? localizedTexts;

  HiveLocalizationConfig({
    this.defaultLanguageCode,
    this.localizedTexts,
  });
}
