// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_episode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) {
  return _PodcastEpisode.fromJson(json);
}

/// @nodoc
mixin _$PodcastEpisode {
  String get wrapperType => throw _privateConstructorUsedError;
  int get trackId => throw _privateConstructorUsedError;
  String get trackName => throw _privateConstructorUsedError;
  String get artworkUrl600 => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get episodeUrl => throw _privateConstructorUsedError;
  int get trackTimeMillis => throw _privateConstructorUsedError;
  String get episodeFileExtension => throw _privateConstructorUsedError;
  DateTime get releaseDate =>
      throw _privateConstructorUsedError; // ➕ Lokale Zusatzfelder
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? get downloadedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get localId => throw _privateConstructorUsedError;

  /// Serializes this PodcastEpisode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PodcastEpisode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PodcastEpisodeCopyWith<PodcastEpisode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PodcastEpisodeCopyWith<$Res> {
  factory $PodcastEpisodeCopyWith(
          PodcastEpisode value, $Res Function(PodcastEpisode) then) =
      _$PodcastEpisodeCopyWithImpl<$Res, PodcastEpisode>;
  @useResult
  $Res call(
      {String wrapperType,
      int trackId,
      String trackName,
      String artworkUrl600,
      String? description,
      String episodeUrl,
      int trackTimeMillis,
      String episodeFileExtension,
      DateTime releaseDate,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DateTime? downloadedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) String? localId});
}

/// @nodoc
class _$PodcastEpisodeCopyWithImpl<$Res, $Val extends PodcastEpisode>
    implements $PodcastEpisodeCopyWith<$Res> {
  _$PodcastEpisodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PodcastEpisode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wrapperType = null,
    Object? trackId = null,
    Object? trackName = null,
    Object? artworkUrl600 = null,
    Object? description = freezed,
    Object? episodeUrl = null,
    Object? trackTimeMillis = null,
    Object? episodeFileExtension = null,
    Object? releaseDate = null,
    Object? downloadedAt = freezed,
    Object? localId = freezed,
  }) {
    return _then(_value.copyWith(
      wrapperType: null == wrapperType
          ? _value.wrapperType
          : wrapperType // ignore: cast_nullable_to_non_nullable
              as String,
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as int,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl600: null == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeUrl: null == episodeUrl
          ? _value.episodeUrl
          : episodeUrl // ignore: cast_nullable_to_non_nullable
              as String,
      trackTimeMillis: null == trackTimeMillis
          ? _value.trackTimeMillis
          : trackTimeMillis // ignore: cast_nullable_to_non_nullable
              as int,
      episodeFileExtension: null == episodeFileExtension
          ? _value.episodeFileExtension
          : episodeFileExtension // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PodcastEpisodeImplCopyWith<$Res>
    implements $PodcastEpisodeCopyWith<$Res> {
  factory _$$PodcastEpisodeImplCopyWith(_$PodcastEpisodeImpl value,
          $Res Function(_$PodcastEpisodeImpl) then) =
      __$$PodcastEpisodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String wrapperType,
      int trackId,
      String trackName,
      String artworkUrl600,
      String? description,
      String episodeUrl,
      int trackTimeMillis,
      String episodeFileExtension,
      DateTime releaseDate,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DateTime? downloadedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) String? localId});
}

/// @nodoc
class __$$PodcastEpisodeImplCopyWithImpl<$Res>
    extends _$PodcastEpisodeCopyWithImpl<$Res, _$PodcastEpisodeImpl>
    implements _$$PodcastEpisodeImplCopyWith<$Res> {
  __$$PodcastEpisodeImplCopyWithImpl(
      _$PodcastEpisodeImpl _value, $Res Function(_$PodcastEpisodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PodcastEpisode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wrapperType = null,
    Object? trackId = null,
    Object? trackName = null,
    Object? artworkUrl600 = null,
    Object? description = freezed,
    Object? episodeUrl = null,
    Object? trackTimeMillis = null,
    Object? episodeFileExtension = null,
    Object? releaseDate = null,
    Object? downloadedAt = freezed,
    Object? localId = freezed,
  }) {
    return _then(_$PodcastEpisodeImpl(
      wrapperType: null == wrapperType
          ? _value.wrapperType
          : wrapperType // ignore: cast_nullable_to_non_nullable
              as String,
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as int,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl600: null == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeUrl: null == episodeUrl
          ? _value.episodeUrl
          : episodeUrl // ignore: cast_nullable_to_non_nullable
              as String,
      trackTimeMillis: null == trackTimeMillis
          ? _value.trackTimeMillis
          : trackTimeMillis // ignore: cast_nullable_to_non_nullable
              as int,
      episodeFileExtension: null == episodeFileExtension
          ? _value.episodeFileExtension
          : episodeFileExtension // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PodcastEpisodeImpl implements _PodcastEpisode {
  const _$PodcastEpisodeImpl(
      {required this.wrapperType,
      required this.trackId,
      required this.trackName,
      required this.artworkUrl600,
      this.description,
      required this.episodeUrl,
      required this.trackTimeMillis,
      required this.episodeFileExtension,
      required this.releaseDate,
      @JsonKey(includeFromJson: false, includeToJson: false) this.downloadedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.localId});

  factory _$PodcastEpisodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PodcastEpisodeImplFromJson(json);

  @override
  final String wrapperType;
  @override
  final int trackId;
  @override
  final String trackName;
  @override
  final String artworkUrl600;
  @override
  final String? description;
  @override
  final String episodeUrl;
  @override
  final int trackTimeMillis;
  @override
  final String episodeFileExtension;
  @override
  final DateTime releaseDate;
// ➕ Lokale Zusatzfelder
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? downloadedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? localId;

  @override
  String toString() {
    return 'PodcastEpisode(wrapperType: $wrapperType, trackId: $trackId, trackName: $trackName, artworkUrl600: $artworkUrl600, description: $description, episodeUrl: $episodeUrl, trackTimeMillis: $trackTimeMillis, episodeFileExtension: $episodeFileExtension, releaseDate: $releaseDate, downloadedAt: $downloadedAt, localId: $localId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PodcastEpisodeImpl &&
            (identical(other.wrapperType, wrapperType) ||
                other.wrapperType == wrapperType) &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.trackName, trackName) ||
                other.trackName == trackName) &&
            (identical(other.artworkUrl600, artworkUrl600) ||
                other.artworkUrl600 == artworkUrl600) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.episodeUrl, episodeUrl) ||
                other.episodeUrl == episodeUrl) &&
            (identical(other.trackTimeMillis, trackTimeMillis) ||
                other.trackTimeMillis == trackTimeMillis) &&
            (identical(other.episodeFileExtension, episodeFileExtension) ||
                other.episodeFileExtension == episodeFileExtension) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt) &&
            (identical(other.localId, localId) || other.localId == localId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      wrapperType,
      trackId,
      trackName,
      artworkUrl600,
      description,
      episodeUrl,
      trackTimeMillis,
      episodeFileExtension,
      releaseDate,
      downloadedAt,
      localId);

  /// Create a copy of PodcastEpisode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PodcastEpisodeImplCopyWith<_$PodcastEpisodeImpl> get copyWith =>
      __$$PodcastEpisodeImplCopyWithImpl<_$PodcastEpisodeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PodcastEpisodeImplToJson(
      this,
    );
  }
}

abstract class _PodcastEpisode implements PodcastEpisode {
  const factory _PodcastEpisode(
      {required final String wrapperType,
      required final int trackId,
      required final String trackName,
      required final String artworkUrl600,
      final String? description,
      required final String episodeUrl,
      required final int trackTimeMillis,
      required final String episodeFileExtension,
      required final DateTime releaseDate,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final DateTime? downloadedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? localId}) = _$PodcastEpisodeImpl;

  factory _PodcastEpisode.fromJson(Map<String, dynamic> json) =
      _$PodcastEpisodeImpl.fromJson;

  @override
  String get wrapperType;
  @override
  int get trackId;
  @override
  String get trackName;
  @override
  String get artworkUrl600;
  @override
  String? get description;
  @override
  String get episodeUrl;
  @override
  int get trackTimeMillis;
  @override
  String get episodeFileExtension;
  @override
  DateTime get releaseDate; // ➕ Lokale Zusatzfelder
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? get downloadedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get localId;

  /// Create a copy of PodcastEpisode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PodcastEpisodeImplCopyWith<_$PodcastEpisodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
