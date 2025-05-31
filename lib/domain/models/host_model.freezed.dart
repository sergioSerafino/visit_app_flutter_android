// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Host _$HostFromJson(Map<String, dynamic> json) {
  return _Host.fromJson(json);
}

/// @nodoc
mixin _$Host {
  int get collectionId => throw _privateConstructorUsedError; // System
  String get hostName => throw _privateConstructorUsedError; // iTunes, RSS
  String get description => throw _privateConstructorUsedError; // RSS
  ContactInfo get contact =>
      throw _privateConstructorUsedError; // aus RSS & JSON
  Branding get branding => throw _privateConstructorUsedError; // aus JSON
  FeatureFlags get features => throw _privateConstructorUsedError; // aus JSON
  LocalizationConfig get localization =>
      throw _privateConstructorUsedError; // JSON
  HostContent get content => throw _privateConstructorUsedError; // JSON
  String? get primaryGenreName =>
      throw _privateConstructorUsedError; // iTunes, RSS
  bool get authTokenRequired => throw _privateConstructorUsedError;
  bool? get debugOnly => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Host to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostCopyWith<Host> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostCopyWith<$Res> {
  factory $HostCopyWith(Host value, $Res Function(Host) then) =
      _$HostCopyWithImpl<$Res, Host>;
  @useResult
  $Res call(
      {int collectionId,
      String hostName,
      String description,
      ContactInfo contact,
      Branding branding,
      FeatureFlags features,
      LocalizationConfig localization,
      HostContent content,
      String? primaryGenreName,
      bool authTokenRequired,
      bool? debugOnly,
      DateTime? lastUpdated});

  $ContactInfoCopyWith<$Res> get contact;
  $BrandingCopyWith<$Res> get branding;
  $FeatureFlagsCopyWith<$Res> get features;
  $LocalizationConfigCopyWith<$Res> get localization;
  $HostContentCopyWith<$Res> get content;
}

/// @nodoc
class _$HostCopyWithImpl<$Res, $Val extends Host>
    implements $HostCopyWith<$Res> {
  _$HostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = null,
    Object? hostName = null,
    Object? description = null,
    Object? contact = null,
    Object? branding = null,
    Object? features = null,
    Object? localization = null,
    Object? content = null,
    Object? primaryGenreName = freezed,
    Object? authTokenRequired = null,
    Object? debugOnly = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      hostName: null == hostName
          ? _value.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as ContactInfo,
      branding: null == branding
          ? _value.branding
          : branding // ignore: cast_nullable_to_non_nullable
              as Branding,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as FeatureFlags,
      localization: null == localization
          ? _value.localization
          : localization // ignore: cast_nullable_to_non_nullable
              as LocalizationConfig,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as HostContent,
      primaryGenreName: freezed == primaryGenreName
          ? _value.primaryGenreName
          : primaryGenreName // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: null == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      debugOnly: freezed == debugOnly
          ? _value.debugOnly
          : debugOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoCopyWith<$Res> get contact {
    return $ContactInfoCopyWith<$Res>(_value.contact, (value) {
      return _then(_value.copyWith(contact: value) as $Val);
    });
  }

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandingCopyWith<$Res> get branding {
    return $BrandingCopyWith<$Res>(_value.branding, (value) {
      return _then(_value.copyWith(branding: value) as $Val);
    });
  }

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeatureFlagsCopyWith<$Res> get features {
    return $FeatureFlagsCopyWith<$Res>(_value.features, (value) {
      return _then(_value.copyWith(features: value) as $Val);
    });
  }

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocalizationConfigCopyWith<$Res> get localization {
    return $LocalizationConfigCopyWith<$Res>(_value.localization, (value) {
      return _then(_value.copyWith(localization: value) as $Val);
    });
  }

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HostContentCopyWith<$Res> get content {
    return $HostContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HostImplCopyWith<$Res> implements $HostCopyWith<$Res> {
  factory _$$HostImplCopyWith(
          _$HostImpl value, $Res Function(_$HostImpl) then) =
      __$$HostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int collectionId,
      String hostName,
      String description,
      ContactInfo contact,
      Branding branding,
      FeatureFlags features,
      LocalizationConfig localization,
      HostContent content,
      String? primaryGenreName,
      bool authTokenRequired,
      bool? debugOnly,
      DateTime? lastUpdated});

  @override
  $ContactInfoCopyWith<$Res> get contact;
  @override
  $BrandingCopyWith<$Res> get branding;
  @override
  $FeatureFlagsCopyWith<$Res> get features;
  @override
  $LocalizationConfigCopyWith<$Res> get localization;
  @override
  $HostContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$HostImplCopyWithImpl<$Res>
    extends _$HostCopyWithImpl<$Res, _$HostImpl>
    implements _$$HostImplCopyWith<$Res> {
  __$$HostImplCopyWithImpl(_$HostImpl _value, $Res Function(_$HostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = null,
    Object? hostName = null,
    Object? description = null,
    Object? contact = null,
    Object? branding = null,
    Object? features = null,
    Object? localization = null,
    Object? content = null,
    Object? primaryGenreName = freezed,
    Object? authTokenRequired = null,
    Object? debugOnly = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$HostImpl(
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      hostName: null == hostName
          ? _value.hostName
          : hostName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as ContactInfo,
      branding: null == branding
          ? _value.branding
          : branding // ignore: cast_nullable_to_non_nullable
              as Branding,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as FeatureFlags,
      localization: null == localization
          ? _value.localization
          : localization // ignore: cast_nullable_to_non_nullable
              as LocalizationConfig,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as HostContent,
      primaryGenreName: freezed == primaryGenreName
          ? _value.primaryGenreName
          : primaryGenreName // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: null == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      debugOnly: freezed == debugOnly
          ? _value.debugOnly
          : debugOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostImpl implements _Host {
  const _$HostImpl(
      {required this.collectionId,
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
      this.lastUpdated});

  factory _$HostImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostImplFromJson(json);

  @override
  final int collectionId;
// System
  @override
  final String hostName;
// iTunes, RSS
  @override
  final String description;
// RSS
  @override
  final ContactInfo contact;
// aus RSS & JSON
  @override
  final Branding branding;
// aus JSON
  @override
  final FeatureFlags features;
// aus JSON
  @override
  final LocalizationConfig localization;
// JSON
  @override
  final HostContent content;
// JSON
  @override
  final String? primaryGenreName;
// iTunes, RSS
  @override
  @JsonKey()
  final bool authTokenRequired;
  @override
  final bool? debugOnly;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'Host(collectionId: $collectionId, hostName: $hostName, description: $description, contact: $contact, branding: $branding, features: $features, localization: $localization, content: $content, primaryGenreName: $primaryGenreName, authTokenRequired: $authTokenRequired, debugOnly: $debugOnly, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostImpl &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.branding, branding) ||
                other.branding == branding) &&
            (identical(other.features, features) ||
                other.features == features) &&
            (identical(other.localization, localization) ||
                other.localization == localization) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.primaryGenreName, primaryGenreName) ||
                other.primaryGenreName == primaryGenreName) &&
            (identical(other.authTokenRequired, authTokenRequired) ||
                other.authTokenRequired == authTokenRequired) &&
            (identical(other.debugOnly, debugOnly) ||
                other.debugOnly == debugOnly) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      collectionId,
      hostName,
      description,
      contact,
      branding,
      features,
      localization,
      content,
      primaryGenreName,
      authTokenRequired,
      debugOnly,
      lastUpdated);

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostImplCopyWith<_$HostImpl> get copyWith =>
      __$$HostImplCopyWithImpl<_$HostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostImplToJson(
      this,
    );
  }
}

abstract class _Host implements Host {
  const factory _Host(
      {required final int collectionId,
      required final String hostName,
      required final String description,
      required final ContactInfo contact,
      required final Branding branding,
      required final FeatureFlags features,
      required final LocalizationConfig localization,
      required final HostContent content,
      final String? primaryGenreName,
      final bool authTokenRequired,
      final bool? debugOnly,
      final DateTime? lastUpdated}) = _$HostImpl;

  factory _Host.fromJson(Map<String, dynamic> json) = _$HostImpl.fromJson;

  @override
  int get collectionId; // System
  @override
  String get hostName; // iTunes, RSS
  @override
  String get description; // RSS
  @override
  ContactInfo get contact; // aus RSS & JSON
  @override
  Branding get branding; // aus JSON
  @override
  FeatureFlags get features; // aus JSON
  @override
  LocalizationConfig get localization; // JSON
  @override
  HostContent get content; // JSON
  @override
  String? get primaryGenreName; // iTunes, RSS
  @override
  bool get authTokenRequired;
  @override
  bool? get debugOnly;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of Host
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostImplCopyWith<_$HostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
