// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Podcast _$PodcastFromJson(Map<String, dynamic> json) {
  return _Podcast.fromJson(json);
}

/// @nodoc
mixin _$Podcast {
  String get wrapperType => throw _privateConstructorUsedError;
  int get collectionId => throw _privateConstructorUsedError;
  String get collectionName => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String get primaryGenreName => throw _privateConstructorUsedError;
  String get artworkUrl600 => throw _privateConstructorUsedError;
  String? get feedUrl => throw _privateConstructorUsedError;
  List<PodcastEpisode> get episodes => throw _privateConstructorUsedError;

  /// Serializes this Podcast to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Podcast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PodcastCopyWith<Podcast> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PodcastCopyWith<$Res> {
  factory $PodcastCopyWith(Podcast value, $Res Function(Podcast) then) =
      _$PodcastCopyWithImpl<$Res, Podcast>;
  @useResult
  $Res call(
      {String wrapperType,
      int collectionId,
      String collectionName,
      String artistName,
      String primaryGenreName,
      String artworkUrl600,
      String? feedUrl,
      List<PodcastEpisode> episodes});
}

/// @nodoc
class _$PodcastCopyWithImpl<$Res, $Val extends Podcast>
    implements $PodcastCopyWith<$Res> {
  _$PodcastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Podcast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wrapperType = null,
    Object? collectionId = null,
    Object? collectionName = null,
    Object? artistName = null,
    Object? primaryGenreName = null,
    Object? artworkUrl600 = null,
    Object? feedUrl = freezed,
    Object? episodes = null,
  }) {
    return _then(_value.copyWith(
      wrapperType: null == wrapperType
          ? _value.wrapperType
          : wrapperType // ignore: cast_nullable_to_non_nullable
              as String,
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      collectionName: null == collectionName
          ? _value.collectionName
          : collectionName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      primaryGenreName: null == primaryGenreName
          ? _value.primaryGenreName
          : primaryGenreName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl600: null == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String,
      feedUrl: freezed == feedUrl
          ? _value.feedUrl
          : feedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      episodes: null == episodes
          ? _value.episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<PodcastEpisode>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PodcastImplCopyWith<$Res> implements $PodcastCopyWith<$Res> {
  factory _$$PodcastImplCopyWith(
          _$PodcastImpl value, $Res Function(_$PodcastImpl) then) =
      __$$PodcastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String wrapperType,
      int collectionId,
      String collectionName,
      String artistName,
      String primaryGenreName,
      String artworkUrl600,
      String? feedUrl,
      List<PodcastEpisode> episodes});
}

/// @nodoc
class __$$PodcastImplCopyWithImpl<$Res>
    extends _$PodcastCopyWithImpl<$Res, _$PodcastImpl>
    implements _$$PodcastImplCopyWith<$Res> {
  __$$PodcastImplCopyWithImpl(
      _$PodcastImpl _value, $Res Function(_$PodcastImpl) _then)
      : super(_value, _then);

  /// Create a copy of Podcast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wrapperType = null,
    Object? collectionId = null,
    Object? collectionName = null,
    Object? artistName = null,
    Object? primaryGenreName = null,
    Object? artworkUrl600 = null,
    Object? feedUrl = freezed,
    Object? episodes = null,
  }) {
    return _then(_$PodcastImpl(
      wrapperType: null == wrapperType
          ? _value.wrapperType
          : wrapperType // ignore: cast_nullable_to_non_nullable
              as String,
      collectionId: null == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int,
      collectionName: null == collectionName
          ? _value.collectionName
          : collectionName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      primaryGenreName: null == primaryGenreName
          ? _value.primaryGenreName
          : primaryGenreName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl600: null == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String,
      feedUrl: freezed == feedUrl
          ? _value.feedUrl
          : feedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      episodes: null == episodes
          ? _value._episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<PodcastEpisode>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PodcastImpl implements _Podcast {
  const _$PodcastImpl(
      {required this.wrapperType,
      required this.collectionId,
      required this.collectionName,
      required this.artistName,
      required this.primaryGenreName,
      required this.artworkUrl600,
      this.feedUrl,
      final List<PodcastEpisode> episodes = const []})
      : _episodes = episodes;

  factory _$PodcastImpl.fromJson(Map<String, dynamic> json) =>
      _$$PodcastImplFromJson(json);

  @override
  final String wrapperType;
  @override
  final int collectionId;
  @override
  final String collectionName;
  @override
  final String artistName;
  @override
  final String primaryGenreName;
  @override
  final String artworkUrl600;
  @override
  final String? feedUrl;
  final List<PodcastEpisode> _episodes;
  @override
  @JsonKey()
  List<PodcastEpisode> get episodes {
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_episodes);
  }

  @override
  String toString() {
    return 'Podcast(wrapperType: $wrapperType, collectionId: $collectionId, collectionName: $collectionName, artistName: $artistName, primaryGenreName: $primaryGenreName, artworkUrl600: $artworkUrl600, feedUrl: $feedUrl, episodes: $episodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PodcastImpl &&
            (identical(other.wrapperType, wrapperType) ||
                other.wrapperType == wrapperType) &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.collectionName, collectionName) ||
                other.collectionName == collectionName) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.primaryGenreName, primaryGenreName) ||
                other.primaryGenreName == primaryGenreName) &&
            (identical(other.artworkUrl600, artworkUrl600) ||
                other.artworkUrl600 == artworkUrl600) &&
            (identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl) &&
            const DeepCollectionEquality().equals(other._episodes, _episodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      wrapperType,
      collectionId,
      collectionName,
      artistName,
      primaryGenreName,
      artworkUrl600,
      feedUrl,
      const DeepCollectionEquality().hash(_episodes));

  /// Create a copy of Podcast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PodcastImplCopyWith<_$PodcastImpl> get copyWith =>
      __$$PodcastImplCopyWithImpl<_$PodcastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PodcastImplToJson(
      this,
    );
  }
}

abstract class _Podcast implements Podcast {
  const factory _Podcast(
      {required final String wrapperType,
      required final int collectionId,
      required final String collectionName,
      required final String artistName,
      required final String primaryGenreName,
      required final String artworkUrl600,
      final String? feedUrl,
      final List<PodcastEpisode> episodes}) = _$PodcastImpl;

  factory _Podcast.fromJson(Map<String, dynamic> json) = _$PodcastImpl.fromJson;

  @override
  String get wrapperType;
  @override
  int get collectionId;
  @override
  String get collectionName;
  @override
  String get artistName;
  @override
  String get primaryGenreName;
  @override
  String get artworkUrl600;
  @override
  String? get feedUrl;
  @override
  List<PodcastEpisode> get episodes;

  /// Create a copy of Podcast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PodcastImplCopyWith<_$PodcastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
