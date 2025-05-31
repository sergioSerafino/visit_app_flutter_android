// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollectionMeta _$CollectionMetaFromJson(Map<String, dynamic> json) {
  return _CollectionMeta.fromJson(json);
}

/// @nodoc
mixin _$CollectionMeta {
  DataOrigin get podcastOrigin => throw _privateConstructorUsedError;
  DataOrigin get episodeOrigin => throw _privateConstructorUsedError;
  DataOrigin? get hostOrigin => throw _privateConstructorUsedError;

  /// Serializes this CollectionMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionMetaCopyWith<CollectionMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionMetaCopyWith<$Res> {
  factory $CollectionMetaCopyWith(
          CollectionMeta value, $Res Function(CollectionMeta) then) =
      _$CollectionMetaCopyWithImpl<$Res, CollectionMeta>;
  @useResult
  $Res call(
      {DataOrigin podcastOrigin,
      DataOrigin episodeOrigin,
      DataOrigin? hostOrigin});

  $DataOriginCopyWith<$Res> get podcastOrigin;
  $DataOriginCopyWith<$Res> get episodeOrigin;
  $DataOriginCopyWith<$Res>? get hostOrigin;
}

/// @nodoc
class _$CollectionMetaCopyWithImpl<$Res, $Val extends CollectionMeta>
    implements $CollectionMetaCopyWith<$Res> {
  _$CollectionMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? podcastOrigin = null,
    Object? episodeOrigin = null,
    Object? hostOrigin = freezed,
  }) {
    return _then(_value.copyWith(
      podcastOrigin: null == podcastOrigin
          ? _value.podcastOrigin
          : podcastOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin,
      episodeOrigin: null == episodeOrigin
          ? _value.episodeOrigin
          : episodeOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin,
      hostOrigin: freezed == hostOrigin
          ? _value.hostOrigin
          : hostOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin?,
    ) as $Val);
  }

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataOriginCopyWith<$Res> get podcastOrigin {
    return $DataOriginCopyWith<$Res>(_value.podcastOrigin, (value) {
      return _then(_value.copyWith(podcastOrigin: value) as $Val);
    });
  }

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataOriginCopyWith<$Res> get episodeOrigin {
    return $DataOriginCopyWith<$Res>(_value.episodeOrigin, (value) {
      return _then(_value.copyWith(episodeOrigin: value) as $Val);
    });
  }

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataOriginCopyWith<$Res>? get hostOrigin {
    if (_value.hostOrigin == null) {
      return null;
    }

    return $DataOriginCopyWith<$Res>(_value.hostOrigin!, (value) {
      return _then(_value.copyWith(hostOrigin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollectionMetaImplCopyWith<$Res>
    implements $CollectionMetaCopyWith<$Res> {
  factory _$$CollectionMetaImplCopyWith(_$CollectionMetaImpl value,
          $Res Function(_$CollectionMetaImpl) then) =
      __$$CollectionMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DataOrigin podcastOrigin,
      DataOrigin episodeOrigin,
      DataOrigin? hostOrigin});

  @override
  $DataOriginCopyWith<$Res> get podcastOrigin;
  @override
  $DataOriginCopyWith<$Res> get episodeOrigin;
  @override
  $DataOriginCopyWith<$Res>? get hostOrigin;
}

/// @nodoc
class __$$CollectionMetaImplCopyWithImpl<$Res>
    extends _$CollectionMetaCopyWithImpl<$Res, _$CollectionMetaImpl>
    implements _$$CollectionMetaImplCopyWith<$Res> {
  __$$CollectionMetaImplCopyWithImpl(
      _$CollectionMetaImpl _value, $Res Function(_$CollectionMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? podcastOrigin = null,
    Object? episodeOrigin = null,
    Object? hostOrigin = freezed,
  }) {
    return _then(_$CollectionMetaImpl(
      podcastOrigin: null == podcastOrigin
          ? _value.podcastOrigin
          : podcastOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin,
      episodeOrigin: null == episodeOrigin
          ? _value.episodeOrigin
          : episodeOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin,
      hostOrigin: freezed == hostOrigin
          ? _value.hostOrigin
          : hostOrigin // ignore: cast_nullable_to_non_nullable
              as DataOrigin?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionMetaImpl implements _CollectionMeta {
  const _$CollectionMetaImpl(
      {required this.podcastOrigin,
      required this.episodeOrigin,
      this.hostOrigin});

  factory _$CollectionMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionMetaImplFromJson(json);

  @override
  final DataOrigin podcastOrigin;
  @override
  final DataOrigin episodeOrigin;
  @override
  final DataOrigin? hostOrigin;

  @override
  String toString() {
    return 'CollectionMeta(podcastOrigin: $podcastOrigin, episodeOrigin: $episodeOrigin, hostOrigin: $hostOrigin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionMetaImpl &&
            (identical(other.podcastOrigin, podcastOrigin) ||
                other.podcastOrigin == podcastOrigin) &&
            (identical(other.episodeOrigin, episodeOrigin) ||
                other.episodeOrigin == episodeOrigin) &&
            (identical(other.hostOrigin, hostOrigin) ||
                other.hostOrigin == hostOrigin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, podcastOrigin, episodeOrigin, hostOrigin);

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionMetaImplCopyWith<_$CollectionMetaImpl> get copyWith =>
      __$$CollectionMetaImplCopyWithImpl<_$CollectionMetaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionMetaImplToJson(
      this,
    );
  }
}

abstract class _CollectionMeta implements CollectionMeta {
  const factory _CollectionMeta(
      {required final DataOrigin podcastOrigin,
      required final DataOrigin episodeOrigin,
      final DataOrigin? hostOrigin}) = _$CollectionMetaImpl;

  factory _CollectionMeta.fromJson(Map<String, dynamic> json) =
      _$CollectionMetaImpl.fromJson;

  @override
  DataOrigin get podcastOrigin;
  @override
  DataOrigin get episodeOrigin;
  @override
  DataOrigin? get hostOrigin;

  /// Create a copy of CollectionMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionMetaImplCopyWith<_$CollectionMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
