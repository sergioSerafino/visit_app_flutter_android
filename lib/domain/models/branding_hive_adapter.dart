import 'package:hive/hive.dart';

part 'branding_hive_adapter.g.dart';

@HiveType(typeId: 21)
class HiveBranding extends HiveObject {
  @HiveField(0)
  String? primaryColorHex;
  @HiveField(1)
  String? secondaryColorHex;
  @HiveField(2)
  String? headerImageUrl;
  @HiveField(3)
  String? themeMode;
  @HiveField(4)
  String? logoUrl;
  @HiveField(5)
  String? assetLogo;

  HiveBranding({
    this.primaryColorHex,
    this.secondaryColorHex,
    this.headerImageUrl,
    this.themeMode,
    this.logoUrl,
    this.assetLogo,
  });
}
