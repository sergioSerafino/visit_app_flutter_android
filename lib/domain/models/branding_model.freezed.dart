// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Branding _$BrandingFromJson(Map<String, dynamic> json) {
  return _Branding.fromJson(json);
}

/// @nodoc
mixin _$Branding {
  String? get primaryColorHex => throw _privateConstructorUsedError;
  String? get secondaryColorHex => throw _privateConstructorUsedError;
  String? get headerImageUrl => throw _privateConstructorUsedError;
  String? get themeMode =>
      throw _privateConstructorUsedError; // "light", "dark", "system"
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Serializes this Branding to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Branding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandingCopyWith<Branding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandingCopyWith<$Res> {
  factory $BrandingCopyWith(Branding value, $Res Function(Branding) then) =
      _$BrandingCopyWithImpl<$Res, Branding>;
  @useResult
  $Res call(
      {String? primaryColorHex,
      String? secondaryColorHex,
      String? headerImageUrl,
      String? themeMode,
      String? logoUrl});
}

/// @nodoc
class _$BrandingCopyWithImpl<$Res, $Val extends Branding>
    implements $BrandingCopyWith<$Res> {
  _$BrandingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Branding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColorHex = freezed,
    Object? secondaryColorHex = freezed,
    Object? headerImageUrl = freezed,
    Object? themeMode = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      primaryColorHex: freezed == primaryColorHex
          ? _value.primaryColorHex
          : primaryColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryColorHex: freezed == secondaryColorHex
          ? _value.secondaryColorHex
          : secondaryColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      headerImageUrl: freezed == headerImageUrl
          ? _value.headerImageUrl
          : headerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      themeMode: freezed == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrandingImplCopyWith<$Res>
    implements $BrandingCopyWith<$Res> {
  factory _$$BrandingImplCopyWith(
          _$BrandingImpl value, $Res Function(_$BrandingImpl) then) =
      __$$BrandingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? primaryColorHex,
      String? secondaryColorHex,
      String? headerImageUrl,
      String? themeMode,
      String? logoUrl});
}

/// @nodoc
class __$$BrandingImplCopyWithImpl<$Res>
    extends _$BrandingCopyWithImpl<$Res, _$BrandingImpl>
    implements _$$BrandingImplCopyWith<$Res> {
  __$$BrandingImplCopyWithImpl(
      _$BrandingImpl _value, $Res Function(_$BrandingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Branding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColorHex = freezed,
    Object? secondaryColorHex = freezed,
    Object? headerImageUrl = freezed,
    Object? themeMode = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(_$BrandingImpl(
      primaryColorHex: freezed == primaryColorHex
          ? _value.primaryColorHex
          : primaryColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryColorHex: freezed == secondaryColorHex
          ? _value.secondaryColorHex
          : secondaryColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      headerImageUrl: freezed == headerImageUrl
          ? _value.headerImageUrl
          : headerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      themeMode: freezed == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandingImpl implements _Branding {
  const _$BrandingImpl(
      {this.primaryColorHex,
      this.secondaryColorHex,
      this.headerImageUrl,
      this.themeMode,
      this.logoUrl});

  factory _$BrandingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandingImplFromJson(json);

  @override
  final String? primaryColorHex;
  @override
  final String? secondaryColorHex;
  @override
  final String? headerImageUrl;
  @override
  final String? themeMode;
// "light", "dark", "system"
  @override
  final String? logoUrl;

  @override
  String toString() {
    return 'Branding(primaryColorHex: $primaryColorHex, secondaryColorHex: $secondaryColorHex, headerImageUrl: $headerImageUrl, themeMode: $themeMode, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandingImpl &&
            (identical(other.primaryColorHex, primaryColorHex) ||
                other.primaryColorHex == primaryColorHex) &&
            (identical(other.secondaryColorHex, secondaryColorHex) ||
                other.secondaryColorHex == secondaryColorHex) &&
            (identical(other.headerImageUrl, headerImageUrl) ||
                other.headerImageUrl == headerImageUrl) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, primaryColorHex,
      secondaryColorHex, headerImageUrl, themeMode, logoUrl);

  /// Create a copy of Branding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandingImplCopyWith<_$BrandingImpl> get copyWith =>
      __$$BrandingImplCopyWithImpl<_$BrandingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandingImplToJson(
      this,
    );
  }
}

abstract class _Branding implements Branding {
  const factory _Branding(
      {final String? primaryColorHex,
      final String? secondaryColorHex,
      final String? headerImageUrl,
      final String? themeMode,
      final String? logoUrl}) = _$BrandingImpl;

  factory _Branding.fromJson(Map<String, dynamic> json) =
      _$BrandingImpl.fromJson;

  @override
  String? get primaryColorHex;
  @override
  String? get secondaryColorHex;
  @override
  String? get headerImageUrl;
  @override
  String? get themeMode; // "light", "dark", "system"
  @override
  String? get logoUrl;

  /// Create a copy of Branding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandingImplCopyWith<_$BrandingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
