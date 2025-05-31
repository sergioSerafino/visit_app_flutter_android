// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_host_collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PodcastHostCollection _$PodcastHostCollectionFromJson(
    Map<String, dynamic> json) {
  return _PodcastHostCollection.fromJson(json);
}

/// @nodoc
mixin _$PodcastHostCollection {
  int get collectionId => throw _privateConstructorUsedError;
  Podcast get podcast => throw _privateConstructorUsedError;
  List<PodcastEpisode> get episodes => throw _privateConstructorUsedError;
  Host? get host => throw _privateConstructorUsedError;
  DateTime? get downloadedAt => throw _privateConstructorUsedError;
  CollectionMeta get meta => throw _privateConstructorUsedError;

  /// Serializes this PodcastHostCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PodcastHostCollectionCopyWith<PodcastHostCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PodcastHostCollectionCopyWith<$Res> {
  factory $PodcastHostCollectionCopyWith(PodcastHostCollection value,
          $Res Function(PodcastHostCollection) then) =
      _$PodcastHostCollectionCopyWithImpl<$Res, PodcastHostCollection>;
  @useResult
  $Res call(
      {int collectionId,
      Podcast podcast,
      List<PodcastEpisode> episodes,
      Host? host,
      DateTime? downloadedAt,
      CollectionMeta meta});

  $PodcastCopyWith<$Res> get podcast;
  $HostCopyWith<$Res>? get host;
  $CollectionMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$PodcastHostCollectionCopyWithImpl<$Res,
        $Val extends PodcastHostCollection>
    implements $PodcastHostCollectionCopyWith<$Res> {
  _$PodcastHostCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = null,
    Object? podcast = null,
    Object? episodes = null,
    Object? host = freezed,
    Object? downloadedAt = freezed,
    Object? meta = null,
  }) {
    return _then(_value.copyWith(
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      podcast: null == podcast
          ? _value.podcast
          : podcast // ignore: cast_nullable_to_non_nullable
              as Podcast,
      episodes: null == episodes
          ? _value.episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<PodcastEpisode>,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as Host?,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as CollectionMeta,
    ) as $Val);
  }

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PodcastCopyWith<$Res> get podcast {
    return $PodcastCopyWith<$Res>(_value.podcast, (value) {
      return _then(_value.copyWith(podcast: value) as $Val);
    });
  }

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HostCopyWith<$Res>? get host {
    if (_value.host == null) {
      return null;
    }

    return $HostCopyWith<$Res>(_value.host!, (value) {
      return _then(_value.copyWith(host: value) as $Val);
    });
  }

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CollectionMetaCopyWith<$Res> get meta {
    return $CollectionMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PodcastHostCollectionImplCopyWith<$Res>
    implements $PodcastHostCollectionCopyWith<$Res> {
  factory _$$PodcastHostCollectionImplCopyWith(
          _$PodcastHostCollectionImpl value,
          $Res Function(_$PodcastHostCollectionImpl) then) =
      __$$PodcastHostCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int collectionId,
      Podcast podcast,
      List<PodcastEpisode> episodes,
      Host? host,
      DateTime? downloadedAt,
      CollectionMeta meta});

  @override
  $PodcastCopyWith<$Res> get podcast;
  @override
  $HostCopyWith<$Res>? get host;
  @override
  $CollectionMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$PodcastHostCollectionImplCopyWithImpl<$Res>
    extends _$PodcastHostCollectionCopyWithImpl<$Res,
        _$PodcastHostCollectionImpl>
    implements _$$PodcastHostCollectionImplCopyWith<$Res> {
  __$$PodcastHostCollectionImplCopyWithImpl(_$PodcastHostCollectionImpl _value,
      $Res Function(_$PodcastHostCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = null,
    Object? podcast = null,
    Object? episodes = null,
    Object? host = freezed,
    Object? downloadedAt = freezed,
    Object? meta = null,
  }) {
    return _then(_$PodcastHostCollectionImpl(
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      podcast: null == podcast
          ? _value.podcast
          : podcast // ignore: cast_nullable_to_non_nullable
              as Podcast,
      episodes: null == episodes
          ? _value._episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<PodcastEpisode>,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as Host?,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as CollectionMeta,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PodcastHostCollectionImpl implements _PodcastHostCollection {
  const _$PodcastHostCollectionImpl(
      {required this.collectionId,
      required this.podcast,
      required final List<PodcastEpisode> episodes,
      this.host,
      this.downloadedAt,
      required this.meta})
      : _episodes = episodes;

  factory _$PodcastHostCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PodcastHostCollectionImplFromJson(json);

  @override
  final int collectionId;
  @override
  final Podcast podcast;
  final List<PodcastEpisode> _episodes;
  @override
  List<PodcastEpisode> get episodes {
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_episodes);
  }

  @override
  final Host? host;
  @override
  final DateTime? downloadedAt;
  @override
  final CollectionMeta meta;

  @override
  String toString() {
    return 'PodcastHostCollection(collectionId: $collectionId, podcast: $podcast, episodes: $episodes, host: $host, downloadedAt: $downloadedAt, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PodcastHostCollectionImpl &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.podcast, podcast) || other.podcast == podcast) &&
            const DeepCollectionEquality().equals(other._episodes, _episodes) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, collectionId, podcast,
      const DeepCollectionEquality().hash(_episodes), host, downloadedAt, meta);

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PodcastHostCollectionImplCopyWith<_$PodcastHostCollectionImpl>
      get copyWith => __$$PodcastHostCollectionImplCopyWithImpl<
          _$PodcastHostCollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PodcastHostCollectionImplToJson(
      this,
    );
  }
}

abstract class _PodcastHostCollection implements PodcastHostCollection {
  const factory _PodcastHostCollection(
      {required final int collectionId,
      required final Podcast podcast,
      required final List<PodcastEpisode> episodes,
      final Host? host,
      final DateTime? downloadedAt,
      required final CollectionMeta meta}) = _$PodcastHostCollectionImpl;

  factory _PodcastHostCollection.fromJson(Map<String, dynamic> json) =
      _$PodcastHostCollectionImpl.fromJson;

  @override
  int get collectionId;
  @override
  Podcast get podcast;
  @override
  List<PodcastEpisode> get episodes;
  @override
  Host? get host;
  @override
  DateTime? get downloadedAt;
  @override
  CollectionMeta get meta;

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PodcastHostCollectionImplCopyWith<_$PodcastHostCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
