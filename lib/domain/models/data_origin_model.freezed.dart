// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_origin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DataOrigin _$DataOriginFromJson(Map<String, dynamic> json) {
  return _DataOrigin.fromJson(json);
}

/// @nodoc
mixin _$DataOrigin {
  DataSourceType get source =>
      throw _privateConstructorUsedError; // Geänderte Enum verwenden
  String get updatedAt => throw _privateConstructorUsedError; // ISO8601
  bool get isFallback => throw _privateConstructorUsedError;

  /// Serializes this DataOrigin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DataOrigin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataOriginCopyWith<DataOrigin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataOriginCopyWith<$Res> {
  factory $DataOriginCopyWith(
          DataOrigin value, $Res Function(DataOrigin) then) =
      _$DataOriginCopyWithImpl<$Res, DataOrigin>;
  @useResult
  $Res call({DataSourceType source, String updatedAt, bool isFallback});
}

/// @nodoc
class _$DataOriginCopyWithImpl<$Res, $Val extends DataOrigin>
    implements $DataOriginCopyWith<$Res> {
  _$DataOriginCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataOrigin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? updatedAt = null,
    Object? isFallback = null,
  }) {
    return _then(_value.copyWith(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DataSourceType,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isFallback: null == isFallback
          ? _value.isFallback
          : isFallback // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataOriginImplCopyWith<$Res>
    implements $DataOriginCopyWith<$Res> {
  factory _$$DataOriginImplCopyWith(
          _$DataOriginImpl value, $Res Function(_$DataOriginImpl) then) =
      __$$DataOriginImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DataSourceType source, String updatedAt, bool isFallback});
}

/// @nodoc
class __$$DataOriginImplCopyWithImpl<$Res>
    extends _$DataOriginCopyWithImpl<$Res, _$DataOriginImpl>
    implements _$$DataOriginImplCopyWith<$Res> {
  __$$DataOriginImplCopyWithImpl(
      _$DataOriginImpl _value, $Res Function(_$DataOriginImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataOrigin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? updatedAt = null,
    Object? isFallback = null,
  }) {
    return _then(_$DataOriginImpl(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DataSourceType,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isFallback: null == isFallback
          ? _value.isFallback
          : isFallback // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataOriginImpl implements _DataOrigin {
  const _$DataOriginImpl(
      {required this.source,
      required this.updatedAt,
      required this.isFallback});

  factory _$DataOriginImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataOriginImplFromJson(json);

  @override
  final DataSourceType source;
// Geänderte Enum verwenden
  @override
  final String updatedAt;
// ISO8601
  @override
  final bool isFallback;

  @override
  String toString() {
    return 'DataOrigin(source: $source, updatedAt: $updatedAt, isFallback: $isFallback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataOriginImpl &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isFallback, isFallback) ||
                other.isFallback == isFallback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, source, updatedAt, isFallback);

  /// Create a copy of DataOrigin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataOriginImplCopyWith<_$DataOriginImpl> get copyWith =>
      __$$DataOriginImplCopyWithImpl<_$DataOriginImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataOriginImplToJson(
      this,
    );
  }
}

abstract class _DataOrigin implements DataOrigin {
  const factory _DataOrigin(
      {required final DataSourceType source,
      required final String updatedAt,
      required final bool isFallback}) = _$DataOriginImpl;

  factory _DataOrigin.fromJson(Map<String, dynamic> json) =
      _$DataOriginImpl.fromJson;

  @override
  DataSourceType get source; // Geänderte Enum verwenden
  @override
  String get updatedAt; // ISO8601
  @override
  bool get isFallback;

  /// Create a copy of DataOrigin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataOriginImplCopyWith<_$DataOriginImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
