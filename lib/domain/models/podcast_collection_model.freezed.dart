// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PodcastCollection _$PodcastCollectionFromJson(Map<String, dynamic> json) {
  return _PodcastCollection.fromJson(json);
}

/// @nodoc
mixin _$PodcastCollection {
  List<Podcast> get podcasts => throw _privateConstructorUsedError;
  DateTime? get downloadedAt => throw _privateConstructorUsedError;

  /// Create a copy of PodcastCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PodcastCollectionCopyWith<PodcastCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PodcastCollectionCopyWith<$Res> {
  factory $PodcastCollectionCopyWith(
          PodcastCollection value, $Res Function(PodcastCollection) then) =
      _$PodcastCollectionCopyWithImpl<$Res, PodcastCollection>;
  @useResult
  $Res call({List<Podcast> podcasts, DateTime? downloadedAt});
}

/// @nodoc
class _$PodcastCollectionCopyWithImpl<$Res, $Val extends PodcastCollection>
    implements $PodcastCollectionCopyWith<$Res> {
  _$PodcastCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PodcastCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? podcasts = null,
    Object? downloadedAt = freezed,
  }) {
    return _then(_value.copyWith(
      podcasts: null == podcasts
          ? _value.podcasts
          : podcasts // ignore: cast_nullable_to_non_nullable
              as List<Podcast>,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PodcastCollectionImplCopyWith<$Res>
    implements $PodcastCollectionCopyWith<$Res> {
  factory _$$PodcastCollectionImplCopyWith(_$PodcastCollectionImpl value,
          $Res Function(_$PodcastCollectionImpl) then) =
      __$$PodcastCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Podcast> podcasts, DateTime? downloadedAt});
}

/// @nodoc
class __$$PodcastCollectionImplCopyWithImpl<$Res>
    extends _$PodcastCollectionCopyWithImpl<$Res, _$PodcastCollectionImpl>
    implements _$$PodcastCollectionImplCopyWith<$Res> {
  __$$PodcastCollectionImplCopyWithImpl(_$PodcastCollectionImpl _value,
      $Res Function(_$PodcastCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PodcastCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? podcasts = null,
    Object? downloadedAt = freezed,
  }) {
    return _then(_$PodcastCollectionImpl(
      podcasts: null == podcasts
          ? _value._podcasts
          : podcasts // ignore: cast_nullable_to_non_nullable
              as List<Podcast>,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PodcastCollectionImpl extends _PodcastCollection {
  const _$PodcastCollectionImpl(
      {required final List<Podcast> podcasts, this.downloadedAt})
      : _podcasts = podcasts,
        super._();

  factory _$PodcastCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PodcastCollectionImplFromJson(json);

  final List<Podcast> _podcasts;
  @override
  List<Podcast> get podcasts {
    if (_podcasts is EqualUnmodifiableListView) return _podcasts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_podcasts);
  }

  @override
  final DateTime? downloadedAt;

  @override
  String toString() {
    return 'PodcastCollection(podcasts: $podcasts, downloadedAt: $downloadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PodcastCollectionImpl &&
            const DeepCollectionEquality().equals(other._podcasts, _podcasts) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_podcasts), downloadedAt);

  /// Create a copy of PodcastCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PodcastCollectionImplCopyWith<_$PodcastCollectionImpl> get copyWith =>
      __$$PodcastCollectionImplCopyWithImpl<_$PodcastCollectionImpl>(
          this, _$identity);
}

abstract class _PodcastCollection extends PodcastCollection {
  const factory _PodcastCollection(
      {required final List<Podcast> podcasts,
      final DateTime? downloadedAt}) = _$PodcastCollectionImpl;
  const _PodcastCollection._() : super._();

  factory _PodcastCollection.fromJson(Map<String, dynamic> json) =
      _$PodcastCollectionImpl.fromJson;

  @override
  List<Podcast> get podcasts;
  @override
  DateTime? get downloadedAt;

  /// Create a copy of PodcastCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PodcastCollectionImplCopyWith<_$PodcastCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
