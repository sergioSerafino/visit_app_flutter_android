import 'package:hive/hive.dart';

part 'contact_info_hive_adapter.g.dart';

@HiveType(typeId: 20)
class HiveContactInfo extends HiveObject {
  @HiveField(0)
  String? email;
  @HiveField(1)
  String? websiteUrl;
  @HiveField(2)
  String? impressumUrl;
  @HiveField(3)
  Map<String, String>? socialLinks;

  HiveContactInfo({
    this.email,
    this.websiteUrl,
    this.impressumUrl,
    this.socialLinks,
  });
}
