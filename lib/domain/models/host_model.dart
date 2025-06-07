// Host Model

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/localization_config_model.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/host_content_model.dart';
import '../../domain/models/feature_flags_model.dart';
import '../../domain/models/contact_info_model.dart';

part 'host_model.freezed.dart';
part 'host_model.g.dart';

@freezed
class Host with _$Host {
  const factory Host({
    required int collectionId, // System
    required String hostName, // iTunes, RSS
    required String description, // RSS
    required ContactInfo contact, // aus RSS & JSON
    required Branding branding, // aus JSON
    required FeatureFlags features, // aus JSON
    required LocalizationConfig localization, // JSON
    required HostContent content, // JSON
    String? primaryGenreName, // iTunes, RSS
    @Default(false) bool authTokenRequired,
    bool? debugOnly,
    DateTime? lastUpdated,
  }) = _Host;

  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);

  static Host empty() {
    return Host(
      collectionId: 0,
      hostName: 'Unbekannt',
      description: '',
      contact: ContactInfo.empty(),
      branding: Branding.empty(),
      features: FeatureFlags.empty(),
      localization: LocalizationConfig.empty(),
      content: HostContent.empty(),
      primaryGenreName: '',
      debugOnly: false,
      lastUpdated: DateTime.now(),
    );
  }
}
