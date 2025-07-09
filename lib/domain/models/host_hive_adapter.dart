import 'package:hive/hive.dart';
import 'contact_info_hive_adapter.dart';
import 'branding_hive_adapter.dart';
import 'feature_flags_hive_adapter.dart';
import 'localization_config_hive_adapter.dart';
import 'host_content_hive_adapter.dart';

part 'host_hive_adapter.g.dart';

@HiveType(typeId: 13)
class HiveHost extends HiveObject {
  @HiveField(0)
  int collectionId;
  @HiveField(1)
  String hostName;
  @HiveField(2)
  String description;
  @HiveField(3)
  HiveContactInfo contact;
  @HiveField(4)
  HiveBranding branding;
  @HiveField(5)
  HiveFeatureFlags features;
  @HiveField(6)
  HiveLocalizationConfig localization;
  @HiveField(7)
  HiveHostContent content;
  @HiveField(8)
  String? primaryGenreName;
  @HiveField(9)
  bool authTokenRequired;
  @HiveField(10)
  bool? debugOnly;
  @HiveField(11)
  DateTime? lastUpdated;
  @HiveField(12)
  String? hostImage;
  @HiveField(13)
  Map<String, String>? sectionTitles;

  HiveHost({
    required this.collectionId,
    required this.hostName,
    required this.description,
    required this.contact,
    required this.branding,
    required this.features,
    required this.localization,
    required this.content,
    this.primaryGenreName,
    this.authTokenRequired = false,
    this.debugOnly,
    this.lastUpdated,
    this.hostImage,
    this.sectionTitles,
  });
}
