// lib/domain/models/branding_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'branding_model.freezed.dart';
part 'branding_model.g.dart';

@freezed
class Branding with _$Branding {
  const factory Branding({
    String? primaryColorHex,
    String? secondaryColorHex,
    String? headerImageUrl,
    String? themeMode, // "light", "dark", "system"
    String? logoUrl,
  }) = _Branding;

  factory Branding.fromJson(Map<String, dynamic> json) =>
      _$BrandingFromJson(json);

  static Branding empty() {
    return const Branding(
      primaryColorHex: null,
      secondaryColorHex: null,
      headerImageUrl: null,
      themeMode: "system",
      logoUrl: null,
    );
  }
}
