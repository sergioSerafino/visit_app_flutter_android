// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return _ContactInfo.fromJson(json);
}

/// @nodoc
mixin _$ContactInfo {
  String? get email => throw _privateConstructorUsedError; // RSS
  String? get websiteUrl => throw _privateConstructorUsedError; // RSS
  String? get impressumUrl => throw _privateConstructorUsedError; // JSON
  Map<String, String>? get socialLinks => throw _privateConstructorUsedError;

  /// Serializes this ContactInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
          ContactInfo value, $Res Function(ContactInfo) then) =
      _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call(
      {String? email,
      String? websiteUrl,
      String? impressumUrl,
      Map<String, String>? socialLinks});
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? websiteUrl = freezed,
    Object? impressumUrl = freezed,
    Object? socialLinks = freezed,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      impressumUrl: freezed == impressumUrl
          ? _value.impressumUrl
          : impressumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
          _$ContactInfoImpl value, $Res Function(_$ContactInfoImpl) then) =
      __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? email,
      String? websiteUrl,
      String? impressumUrl,
      Map<String, String>? socialLinks});
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
      _$ContactInfoImpl _value, $Res Function(_$ContactInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? websiteUrl = freezed,
    Object? impressumUrl = freezed,
    Object? socialLinks = freezed,
  }) {
    return _then(_$ContactInfoImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      impressumUrl: freezed == impressumUrl
          ? _value.impressumUrl
          : impressumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoImpl implements _ContactInfo {
  const _$ContactInfoImpl(
      {this.email,
      this.websiteUrl,
      this.impressumUrl,
      final Map<String, String>? socialLinks})
      : _socialLinks = socialLinks;

  factory _$ContactInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoImplFromJson(json);

  @override
  final String? email;
// RSS
  @override
  final String? websiteUrl;
// RSS
  @override
  final String? impressumUrl;
// JSON
  final Map<String, String>? _socialLinks;
// JSON
  @override
  Map<String, String>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ContactInfo(email: $email, websiteUrl: $websiteUrl, impressumUrl: $impressumUrl, socialLinks: $socialLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.impressumUrl, impressumUrl) ||
                other.impressumUrl == impressumUrl) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, websiteUrl, impressumUrl,
      const DeepCollectionEquality().hash(_socialLinks));

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoImplToJson(
      this,
    );
  }
}

abstract class _ContactInfo implements ContactInfo {
  const factory _ContactInfo(
      {final String? email,
      final String? websiteUrl,
      final String? impressumUrl,
      final Map<String, String>? socialLinks}) = _$ContactInfoImpl;

  factory _ContactInfo.fromJson(Map<String, dynamic> json) =
      _$ContactInfoImpl.fromJson;

  @override
  String? get email; // RSS
  @override
  String? get websiteUrl; // RSS
  @override
  String? get impressumUrl; // JSON
  @override
  Map<String, String>? get socialLinks;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
