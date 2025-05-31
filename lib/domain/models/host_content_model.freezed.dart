// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HostContent _$HostContentFromJson(Map<String, dynamic> json) {
  return _HostContent.fromJson(json);
}

/// @nodoc
mixin _$HostContent {
  String? get bio => throw _privateConstructorUsedError;
  String? get mission => throw _privateConstructorUsedError;
  String? get rss => throw _privateConstructorUsedError; // feedUrl aus RSS
  List<Link>? get links => throw _privateConstructorUsedError;

  /// Serializes this HostContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostContentCopyWith<HostContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostContentCopyWith<$Res> {
  factory $HostContentCopyWith(
          HostContent value, $Res Function(HostContent) then) =
      _$HostContentCopyWithImpl<$Res, HostContent>;
  @useResult
  $Res call({String? bio, String? mission, String? rss, List<Link>? links});
}

/// @nodoc
class _$HostContentCopyWithImpl<$Res, $Val extends HostContent>
    implements $HostContentCopyWith<$Res> {
  _$HostContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? mission = freezed,
    Object? rss = freezed,
    Object? links = freezed,
  }) {
    return _then(_value.copyWith(
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mission: freezed == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as String?,
      rss: freezed == rss
          ? _value.rss
          : rss // ignore: cast_nullable_to_non_nullable
              as String?,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostContentImplCopyWith<$Res>
    implements $HostContentCopyWith<$Res> {
  factory _$$HostContentImplCopyWith(
          _$HostContentImpl value, $Res Function(_$HostContentImpl) then) =
      __$$HostContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? bio, String? mission, String? rss, List<Link>? links});
}

/// @nodoc
class __$$HostContentImplCopyWithImpl<$Res>
    extends _$HostContentCopyWithImpl<$Res, _$HostContentImpl>
    implements _$$HostContentImplCopyWith<$Res> {
  __$$HostContentImplCopyWithImpl(
      _$HostContentImpl _value, $Res Function(_$HostContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? mission = freezed,
    Object? rss = freezed,
    Object? links = freezed,
  }) {
    return _then(_$HostContentImpl(
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mission: freezed == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as String?,
      rss: freezed == rss
          ? _value.rss
          : rss // ignore: cast_nullable_to_non_nullable
              as String?,
      links: freezed == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostContentImpl implements _HostContent {
  const _$HostContentImpl(
      {this.bio, this.mission, this.rss, final List<Link>? links})
      : _links = links;

  factory _$HostContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostContentImplFromJson(json);

  @override
  final String? bio;
  @override
  final String? mission;
  @override
  final String? rss;
// feedUrl aus RSS
  final List<Link>? _links;
// feedUrl aus RSS
  @override
  List<Link>? get links {
    final value = _links;
    if (value == null) return null;
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HostContent(bio: $bio, mission: $mission, rss: $rss, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostContentImpl &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.mission, mission) || other.mission == mission) &&
            (identical(other.rss, rss) || other.rss == rss) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bio, mission, rss,
      const DeepCollectionEquality().hash(_links));

  /// Create a copy of HostContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostContentImplCopyWith<_$HostContentImpl> get copyWith =>
      __$$HostContentImplCopyWithImpl<_$HostContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostContentImplToJson(
      this,
    );
  }
}

abstract class _HostContent implements HostContent {
  const factory _HostContent(
      {final String? bio,
      final String? mission,
      final String? rss,
      final List<Link>? links}) = _$HostContentImpl;

  factory _HostContent.fromJson(Map<String, dynamic> json) =
      _$HostContentImpl.fromJson;

  @override
  String? get bio;
  @override
  String? get mission;
  @override
  String? get rss; // feedUrl aus RSS
  @override
  List<Link>? get links;

  /// Create a copy of HostContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostContentImplCopyWith<_$HostContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
