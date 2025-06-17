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
    String? hostImage,
  }) = _Host;

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        collectionId: json['collectionId'] as int,
        hostName: json['hostName'] as String,
        description: json['description'] as String,
        contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
        branding: Branding.fromJson(json['branding'] as Map<String, dynamic>),
        features:
            FeatureFlags.fromJson(json['features'] as Map<String, dynamic>),
        localization: LocalizationConfig.fromJson(
            json['localization'] as Map<String, dynamic>),
        content: HostContent.fromJson(json['content'] as Map<String, dynamic>),
        primaryGenreName: json['primaryGenreName'] as String?,
        authTokenRequired: json['authTokenRequired'] as bool? ?? false,
        debugOnly: json['debugOnly'] as bool?,
        lastUpdated: json['lastUpdated'] == null
            ? null
            : DateTime.parse(json['lastUpdated'] as String),
        hostImage: json['hostImage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'collectionId': collectionId,
        'hostName': hostName,
        'description': description,
        'contact': contact.toJson(),
        'branding': branding.toJson(),
        'features': features.toJson(),
        'localization': localization.toJson(),
        'content': content.toJson(),
        'primaryGenreName': primaryGenreName,
        'authTokenRequired': authTokenRequired,
        'debugOnly': debugOnly,
        'lastUpdated': lastUpdated?.toIso8601String(),
        'hostImage': hostImage,
      };

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
      hostImage: null,
    );
  }
}
