// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localization_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocalizationConfig _$LocalizationConfigFromJson(Map<String, dynamic> json) {
  return _LocalizationConfig.fromJson(json);
}

/// @nodoc
mixin _$LocalizationConfig {
  String? get defaultLanguageCode =>
      throw _privateConstructorUsedError; // aus RSS oder JSON
  Map<String, String>? get localizedTexts => throw _privateConstructorUsedError;

  /// Serializes this LocalizationConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalizationConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalizationConfigCopyWith<LocalizationConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizationConfigCopyWith<$Res> {
  factory $LocalizationConfigCopyWith(
          LocalizationConfig value, $Res Function(LocalizationConfig) then) =
      _$LocalizationConfigCopyWithImpl<$Res, LocalizationConfig>;
  @useResult
  $Res call({String? defaultLanguageCode, Map<String, String>? localizedTexts});
}

/// @nodoc
class _$LocalizationConfigCopyWithImpl<$Res, $Val extends LocalizationConfig>
    implements $LocalizationConfigCopyWith<$Res> {
  _$LocalizationConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalizationConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultLanguageCode = freezed,
    Object? localizedTexts = freezed,
  }) {
    return _then(_value.copyWith(
      defaultLanguageCode: freezed == defaultLanguageCode
          ? _value.defaultLanguageCode
          : defaultLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      localizedTexts: freezed == localizedTexts
          ? _value.localizedTexts
          : localizedTexts // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalizationConfigImplCopyWith<$Res>
    implements $LocalizationConfigCopyWith<$Res> {
  factory _$$LocalizationConfigImplCopyWith(_$LocalizationConfigImpl value,
          $Res Function(_$LocalizationConfigImpl) then) =
      __$$LocalizationConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? defaultLanguageCode, Map<String, String>? localizedTexts});
}

/// @nodoc
class __$$LocalizationConfigImplCopyWithImpl<$Res>
    extends _$LocalizationConfigCopyWithImpl<$Res, _$LocalizationConfigImpl>
    implements _$$LocalizationConfigImplCopyWith<$Res> {
  __$$LocalizationConfigImplCopyWithImpl(_$LocalizationConfigImpl _value,
      $Res Function(_$LocalizationConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalizationConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultLanguageCode = freezed,
    Object? localizedTexts = freezed,
  }) {
    return _then(_$LocalizationConfigImpl(
      defaultLanguageCode: freezed == defaultLanguageCode
          ? _value.defaultLanguageCode
          : defaultLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      localizedTexts: freezed == localizedTexts
          ? _value._localizedTexts
          : localizedTexts // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalizationConfigImpl implements _LocalizationConfig {
  const _$LocalizationConfigImpl(
      {this.defaultLanguageCode, final Map<String, String>? localizedTexts})
      : _localizedTexts = localizedTexts;

  factory _$LocalizationConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalizationConfigImplFromJson(json);

  @override
  final String? defaultLanguageCode;
// aus RSS oder JSON
  final Map<String, String>? _localizedTexts;
// aus RSS oder JSON
  @override
  Map<String, String>? get localizedTexts {
    final value = _localizedTexts;
    if (value == null) return null;
    if (_localizedTexts is EqualUnmodifiableMapView) return _localizedTexts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LocalizationConfig(defaultLanguageCode: $defaultLanguageCode, localizedTexts: $localizedTexts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizationConfigImpl &&
            (identical(other.defaultLanguageCode, defaultLanguageCode) ||
                other.defaultLanguageCode == defaultLanguageCode) &&
            const DeepCollectionEquality()
                .equals(other._localizedTexts, _localizedTexts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, defaultLanguageCode,
      const DeepCollectionEquality().hash(_localizedTexts));

  /// Create a copy of LocalizationConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizationConfigImplCopyWith<_$LocalizationConfigImpl> get copyWith =>
      __$$LocalizationConfigImplCopyWithImpl<_$LocalizationConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalizationConfigImplToJson(
      this,
    );
  }
}

abstract class _LocalizationConfig implements LocalizationConfig {
  const factory _LocalizationConfig(
      {final String? defaultLanguageCode,
      final Map<String, String>? localizedTexts}) = _$LocalizationConfigImpl;

  factory _LocalizationConfig.fromJson(Map<String, dynamic> json) =
      _$LocalizationConfigImpl.fromJson;

  @override
  String? get defaultLanguageCode; // aus RSS oder JSON
  @override
  Map<String, String>? get localizedTexts;

  /// Create a copy of LocalizationConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalizationConfigImplCopyWith<_$LocalizationConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
