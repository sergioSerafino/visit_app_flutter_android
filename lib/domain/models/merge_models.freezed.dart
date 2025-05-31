// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merge_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItunesData _$ItunesDataFromJson(Map<String, dynamic> json) {
  return _ItunesData.fromJson(json);
}

/// @nodoc
mixin _$ItunesData {
  int? get collectionId => throw _privateConstructorUsedError;
  String? get trackName => throw _privateConstructorUsedError;
  String? get shortDescription => throw _privateConstructorUsedError;
  String? get artworkUrl600 => throw _privateConstructorUsedError;
  String? get artistName => throw _privateConstructorUsedError;
  String? get feedUrl => throw _privateConstructorUsedError;

  /// Serializes this ItunesData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItunesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItunesDataCopyWith<ItunesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItunesDataCopyWith<$Res> {
  factory $ItunesDataCopyWith(
          ItunesData value, $Res Function(ItunesData) then) =
      _$ItunesDataCopyWithImpl<$Res, ItunesData>;
  @useResult
  $Res call(
      {int? collectionId,
      String? trackName,
      String? shortDescription,
      String? artworkUrl600,
      String? artistName,
      String? feedUrl});
}

/// @nodoc
class _$ItunesDataCopyWithImpl<$Res, $Val extends ItunesData>
    implements $ItunesDataCopyWith<$Res> {
  _$ItunesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItunesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = freezed,
    Object? trackName = freezed,
    Object? shortDescription = freezed,
    Object? artworkUrl600 = freezed,
    Object? artistName = freezed,
    Object? feedUrl = freezed,
  }) {
    return _then(_value.copyWith(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      trackName: freezed == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      artworkUrl600: freezed == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String?,
      artistName: freezed == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String?,
      feedUrl: freezed == feedUrl
          ? _value.feedUrl
          : feedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItunesDataImplCopyWith<$Res>
    implements $ItunesDataCopyWith<$Res> {
  factory _$$ItunesDataImplCopyWith(
          _$ItunesDataImpl value, $Res Function(_$ItunesDataImpl) then) =
      __$$ItunesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? collectionId,
      String? trackName,
      String? shortDescription,
      String? artworkUrl600,
      String? artistName,
      String? feedUrl});
}

/// @nodoc
class __$$ItunesDataImplCopyWithImpl<$Res>
    extends _$ItunesDataCopyWithImpl<$Res, _$ItunesDataImpl>
    implements _$$ItunesDataImplCopyWith<$Res> {
  __$$ItunesDataImplCopyWithImpl(
      _$ItunesDataImpl _value, $Res Function(_$ItunesDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItunesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = freezed,
    Object? trackName = freezed,
    Object? shortDescription = freezed,
    Object? artworkUrl600 = freezed,
    Object? artistName = freezed,
    Object? feedUrl = freezed,
  }) {
    return _then(_$ItunesDataImpl(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      trackName: freezed == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      artworkUrl600: freezed == artworkUrl600
          ? _value.artworkUrl600
          : artworkUrl600 // ignore: cast_nullable_to_non_nullable
              as String?,
      artistName: freezed == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String?,
      feedUrl: freezed == feedUrl
          ? _value.feedUrl
          : feedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItunesDataImpl implements _ItunesData {
  const _$ItunesDataImpl(
      {this.collectionId,
      this.trackName,
      this.shortDescription,
      this.artworkUrl600,
      this.artistName,
      this.feedUrl});

  factory _$ItunesDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItunesDataImplFromJson(json);

  @override
  final int? collectionId;
  @override
  final String? trackName;
  @override
  final String? shortDescription;
  @override
  final String? artworkUrl600;
  @override
  final String? artistName;
  @override
  final String? feedUrl;

  @override
  String toString() {
    return 'ItunesData(collectionId: $collectionId, trackName: $trackName, shortDescription: $shortDescription, artworkUrl600: $artworkUrl600, artistName: $artistName, feedUrl: $feedUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItunesDataImpl &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.trackName, trackName) ||
                other.trackName == trackName) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.artworkUrl600, artworkUrl600) ||
                other.artworkUrl600 == artworkUrl600) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, collectionId, trackName,
      shortDescription, artworkUrl600, artistName, feedUrl);

  /// Create a copy of ItunesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItunesDataImplCopyWith<_$ItunesDataImpl> get copyWith =>
      __$$ItunesDataImplCopyWithImpl<_$ItunesDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItunesDataImplToJson(
      this,
    );
  }
}

abstract class _ItunesData implements ItunesData {
  const factory _ItunesData(
      {final int? collectionId,
      final String? trackName,
      final String? shortDescription,
      final String? artworkUrl600,
      final String? artistName,
      final String? feedUrl}) = _$ItunesDataImpl;

  factory _ItunesData.fromJson(Map<String, dynamic> json) =
      _$ItunesDataImpl.fromJson;

  @override
  int? get collectionId;
  @override
  String? get trackName;
  @override
  String? get shortDescription;
  @override
  String? get artworkUrl600;
  @override
  String? get artistName;
  @override
  String? get feedUrl;

  /// Create a copy of ItunesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItunesDataImplCopyWith<_$ItunesDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RssData _$RssDataFromJson(Map<String, dynamic> json) {
  return _RssData.fromJson(json);
}

/// @nodoc
mixin _$RssData {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get ownerEmail => throw _privateConstructorUsedError;

  /// Serializes this RssData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RssData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RssDataCopyWith<RssData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RssDataCopyWith<$Res> {
  factory $RssDataCopyWith(RssData value, $Res Function(RssData) then) =
      _$RssDataCopyWithImpl<$Res, RssData>;
  @useResult
  $Res call(
      {String? title,
      String? description,
      String? imageUrl,
      String? author,
      String? ownerEmail});
}

/// @nodoc
class _$RssDataCopyWithImpl<$Res, $Val extends RssData>
    implements $RssDataCopyWith<$Res> {
  _$RssDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RssData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? author = freezed,
    Object? ownerEmail = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerEmail: freezed == ownerEmail
          ? _value.ownerEmail
          : ownerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RssDataImplCopyWith<$Res> implements $RssDataCopyWith<$Res> {
  factory _$$RssDataImplCopyWith(
          _$RssDataImpl value, $Res Function(_$RssDataImpl) then) =
      __$$RssDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      String? imageUrl,
      String? author,
      String? ownerEmail});
}

/// @nodoc
class __$$RssDataImplCopyWithImpl<$Res>
    extends _$RssDataCopyWithImpl<$Res, _$RssDataImpl>
    implements _$$RssDataImplCopyWith<$Res> {
  __$$RssDataImplCopyWithImpl(
      _$RssDataImpl _value, $Res Function(_$RssDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RssData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? author = freezed,
    Object? ownerEmail = freezed,
  }) {
    return _then(_$RssDataImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerEmail: freezed == ownerEmail
          ? _value.ownerEmail
          : ownerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RssDataImpl implements _RssData {
  const _$RssDataImpl(
      {this.title,
      this.description,
      this.imageUrl,
      this.author,
      this.ownerEmail});

  factory _$RssDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RssDataImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? author;
  @override
  final String? ownerEmail;

  @override
  String toString() {
    return 'RssData(title: $title, description: $description, imageUrl: $imageUrl, author: $author, ownerEmail: $ownerEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RssDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.ownerEmail, ownerEmail) ||
                other.ownerEmail == ownerEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, imageUrl, author, ownerEmail);

  /// Create a copy of RssData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RssDataImplCopyWith<_$RssDataImpl> get copyWith =>
      __$$RssDataImplCopyWithImpl<_$RssDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RssDataImplToJson(
      this,
    );
  }
}

abstract class _RssData implements RssData {
  const factory _RssData(
      {final String? title,
      final String? description,
      final String? imageUrl,
      final String? author,
      final String? ownerEmail}) = _$RssDataImpl;

  factory _RssData.fromJson(Map<String, dynamic> json) = _$RssDataImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get author;
  @override
  String? get ownerEmail;

  /// Create a copy of RssData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RssDataImplCopyWith<_$RssDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocalJsonData _$LocalJsonDataFromJson(Map<String, dynamic> json) {
  return _LocalJsonData.fromJson(json);
}

/// @nodoc
mixin _$LocalJsonData {
  int? get collectionId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  bool? get authTokenRequired => throw _privateConstructorUsedError;
  List<String>? get featureFlags => throw _privateConstructorUsedError;

  /// Serializes this LocalJsonData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalJsonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalJsonDataCopyWith<LocalJsonData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalJsonDataCopyWith<$Res> {
  factory $LocalJsonDataCopyWith(
          LocalJsonData value, $Res Function(LocalJsonData) then) =
      _$LocalJsonDataCopyWithImpl<$Res, LocalJsonData>;
  @useResult
  $Res call(
      {int? collectionId,
      String? title,
      String? description,
      String? imageUrl,
      String? author,
      String? contactEmail,
      bool? authTokenRequired,
      List<String>? featureFlags});
}

/// @nodoc
class _$LocalJsonDataCopyWithImpl<$Res, $Val extends LocalJsonData>
    implements $LocalJsonDataCopyWith<$Res> {
  _$LocalJsonDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalJsonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? author = freezed,
    Object? contactEmail = freezed,
    Object? authTokenRequired = freezed,
    Object? featureFlags = freezed,
  }) {
    return _then(_value.copyWith(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: freezed == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      featureFlags: freezed == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalJsonDataImplCopyWith<$Res>
    implements $LocalJsonDataCopyWith<$Res> {
  factory _$$LocalJsonDataImplCopyWith(
          _$LocalJsonDataImpl value, $Res Function(_$LocalJsonDataImpl) then) =
      __$$LocalJsonDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? collectionId,
      String? title,
      String? description,
      String? imageUrl,
      String? author,
      String? contactEmail,
      bool? authTokenRequired,
      List<String>? featureFlags});
}

/// @nodoc
class __$$LocalJsonDataImplCopyWithImpl<$Res>
    extends _$LocalJsonDataCopyWithImpl<$Res, _$LocalJsonDataImpl>
    implements _$$LocalJsonDataImplCopyWith<$Res> {
  __$$LocalJsonDataImplCopyWithImpl(
      _$LocalJsonDataImpl _value, $Res Function(_$LocalJsonDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalJsonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? author = freezed,
    Object? contactEmail = freezed,
    Object? authTokenRequired = freezed,
    Object? featureFlags = freezed,
  }) {
    return _then(_$LocalJsonDataImpl(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: freezed == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      featureFlags: freezed == featureFlags
          ? _value._featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalJsonDataImpl implements _LocalJsonData {
  const _$LocalJsonDataImpl(
      {this.collectionId,
      this.title,
      this.description,
      this.imageUrl,
      this.author,
      this.contactEmail,
      this.authTokenRequired,
      final List<String>? featureFlags})
      : _featureFlags = featureFlags;

  factory _$LocalJsonDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalJsonDataImplFromJson(json);

  @override
  final int? collectionId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? author;
  @override
  final String? contactEmail;
  @override
  final bool? authTokenRequired;
  final List<String>? _featureFlags;
  @override
  List<String>? get featureFlags {
    final value = _featureFlags;
    if (value == null) return null;
    if (_featureFlags is EqualUnmodifiableListView) return _featureFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LocalJsonData(collectionId: $collectionId, title: $title, description: $description, imageUrl: $imageUrl, author: $author, contactEmail: $contactEmail, authTokenRequired: $authTokenRequired, featureFlags: $featureFlags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalJsonDataImpl &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.authTokenRequired, authTokenRequired) ||
                other.authTokenRequired == authTokenRequired) &&
            const DeepCollectionEquality()
                .equals(other._featureFlags, _featureFlags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      collectionId,
      title,
      description,
      imageUrl,
      author,
      contactEmail,
      authTokenRequired,
      const DeepCollectionEquality().hash(_featureFlags));

  /// Create a copy of LocalJsonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalJsonDataImplCopyWith<_$LocalJsonDataImpl> get copyWith =>
      __$$LocalJsonDataImplCopyWithImpl<_$LocalJsonDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalJsonDataImplToJson(
      this,
    );
  }
}

abstract class _LocalJsonData implements LocalJsonData {
  const factory _LocalJsonData(
      {final int? collectionId,
      final String? title,
      final String? description,
      final String? imageUrl,
      final String? author,
      final String? contactEmail,
      final bool? authTokenRequired,
      final List<String>? featureFlags}) = _$LocalJsonDataImpl;

  factory _LocalJsonData.fromJson(Map<String, dynamic> json) =
      _$LocalJsonDataImpl.fromJson;

  @override
  int? get collectionId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get author;
  @override
  String? get contactEmail;
  @override
  bool? get authTokenRequired;
  @override
  List<String>? get featureFlags;

  /// Create a copy of LocalJsonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalJsonDataImplCopyWith<_$LocalJsonDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PodcastHostCollection _$PodcastHostCollectionFromJson(
    Map<String, dynamic> json) {
  return _PodcastHostCollection.fromJson(json);
}

/// @nodoc
mixin _$PodcastHostCollection {
  int? get collectionId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  bool? get authTokenRequired => throw _privateConstructorUsedError;
  bool? get isManagedCollection => throw _privateConstructorUsedError;
  List<String>? get featureFlags => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

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
      {int? collectionId,
      String? title,
      String? description,
      String? logoUrl,
      String? author,
      String? contactEmail,
      bool? authTokenRequired,
      bool? isManagedCollection,
      List<String>? featureFlags,
      DateTime? lastUpdated});
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
    Object? collectionId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? author = freezed,
    Object? contactEmail = freezed,
    Object? authTokenRequired = freezed,
    Object? isManagedCollection = freezed,
    Object? featureFlags = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: freezed == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      isManagedCollection: freezed == isManagedCollection
          ? _value.isManagedCollection
          : isManagedCollection // ignore: cast_nullable_to_non_nullable
              as bool?,
      featureFlags: freezed == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
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
      {int? collectionId,
      String? title,
      String? description,
      String? logoUrl,
      String? author,
      String? contactEmail,
      bool? authTokenRequired,
      bool? isManagedCollection,
      List<String>? featureFlags,
      DateTime? lastUpdated});
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
    Object? collectionId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? author = freezed,
    Object? contactEmail = freezed,
    Object? authTokenRequired = freezed,
    Object? isManagedCollection = freezed,
    Object? featureFlags = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$PodcastHostCollectionImpl(
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      authTokenRequired: freezed == authTokenRequired
          ? _value.authTokenRequired
          : authTokenRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      isManagedCollection: freezed == isManagedCollection
          ? _value.isManagedCollection
          : isManagedCollection // ignore: cast_nullable_to_non_nullable
              as bool?,
      featureFlags: freezed == featureFlags
          ? _value._featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PodcastHostCollectionImpl implements _PodcastHostCollection {
  const _$PodcastHostCollectionImpl(
      {this.collectionId,
      this.title,
      this.description,
      this.logoUrl,
      this.author,
      this.contactEmail,
      this.authTokenRequired,
      this.isManagedCollection,
      final List<String>? featureFlags,
      this.lastUpdated})
      : _featureFlags = featureFlags;

  factory _$PodcastHostCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PodcastHostCollectionImplFromJson(json);

  @override
  final int? collectionId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? author;
  @override
  final String? contactEmail;
  @override
  final bool? authTokenRequired;
  @override
  final bool? isManagedCollection;
  final List<String>? _featureFlags;
  @override
  List<String>? get featureFlags {
    final value = _featureFlags;
    if (value == null) return null;
    if (_featureFlags is EqualUnmodifiableListView) return _featureFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'PodcastHostCollection(collectionId: $collectionId, title: $title, description: $description, logoUrl: $logoUrl, author: $author, contactEmail: $contactEmail, authTokenRequired: $authTokenRequired, isManagedCollection: $isManagedCollection, featureFlags: $featureFlags, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PodcastHostCollectionImpl &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.authTokenRequired, authTokenRequired) ||
                other.authTokenRequired == authTokenRequired) &&
            (identical(other.isManagedCollection, isManagedCollection) ||
                other.isManagedCollection == isManagedCollection) &&
            const DeepCollectionEquality()
                .equals(other._featureFlags, _featureFlags) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      collectionId,
      title,
      description,
      logoUrl,
      author,
      contactEmail,
      authTokenRequired,
      isManagedCollection,
      const DeepCollectionEquality().hash(_featureFlags),
      lastUpdated);

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
      {final int? collectionId,
      final String? title,
      final String? description,
      final String? logoUrl,
      final String? author,
      final String? contactEmail,
      final bool? authTokenRequired,
      final bool? isManagedCollection,
      final List<String>? featureFlags,
      final DateTime? lastUpdated}) = _$PodcastHostCollectionImpl;

  factory _PodcastHostCollection.fromJson(Map<String, dynamic> json) =
      _$PodcastHostCollectionImpl.fromJson;

  @override
  int? get collectionId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get author;
  @override
  String? get contactEmail;
  @override
  bool? get authTokenRequired;
  @override
  bool? get isManagedCollection;
  @override
  List<String>? get featureFlags;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of PodcastHostCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PodcastHostCollectionImplCopyWith<_$PodcastHostCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
