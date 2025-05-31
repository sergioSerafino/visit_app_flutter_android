// \lib\domain\models\contact_info_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_model.freezed.dart';
part 'contact_info_model.g.dart';

@freezed
class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    String? email, // RSS
    String? websiteUrl, // RSS
    String? impressumUrl, // JSON
    Map<String, String>? socialLinks, // JSON
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);

  static ContactInfo empty() {
    return const ContactInfo(
      email: null,
      websiteUrl: null,
      impressumUrl: null,
      socialLinks: {},
    );
  }
}
