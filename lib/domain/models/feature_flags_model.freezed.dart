// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_flags_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeatureFlags _$FeatureFlagsFromJson(Map<String, dynamic> json) {
  return _FeatureFlags.fromJson(json);
}

/// @nodoc
mixin _$FeatureFlags {
  bool? get showPortfolioTab => throw _privateConstructorUsedError;
  bool? get enableContactForm => throw _privateConstructorUsedError;
  bool? get showPodcastGenre => throw _privateConstructorUsedError;
  String? get customStartTab => throw _privateConstructorUsedError;

  /// Serializes this FeatureFlags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureFlagsCopyWith<FeatureFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureFlagsCopyWith<$Res> {
  factory $FeatureFlagsCopyWith(
          FeatureFlags value, $Res Function(FeatureFlags) then) =
      _$FeatureFlagsCopyWithImpl<$Res, FeatureFlags>;
  @useResult
  $Res call(
      {bool? showPortfolioTab,
      bool? enableContactForm,
      bool? showPodcastGenre,
      String? customStartTab});
}

/// @nodoc
class _$FeatureFlagsCopyWithImpl<$Res, $Val extends FeatureFlags>
    implements $FeatureFlagsCopyWith<$Res> {
  _$FeatureFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showPortfolioTab = freezed,
    Object? enableContactForm = freezed,
    Object? showPodcastGenre = freezed,
    Object? customStartTab = freezed,
  }) {
    return _then(_value.copyWith(
      showPortfolioTab: freezed == showPortfolioTab
          ? _value.showPortfolioTab
          : showPortfolioTab // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableContactForm: freezed == enableContactForm
          ? _value.enableContactForm
          : enableContactForm // ignore: cast_nullable_to_non_nullable
              as bool?,
      showPodcastGenre: freezed == showPodcastGenre
          ? _value.showPodcastGenre
          : showPodcastGenre // ignore: cast_nullable_to_non_nullable
              as bool?,
      customStartTab: freezed == customStartTab
          ? _value.customStartTab
          : customStartTab // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureFlagsImplCopyWith<$Res>
    implements $FeatureFlagsCopyWith<$Res> {
  factory _$$FeatureFlagsImplCopyWith(
          _$FeatureFlagsImpl value, $Res Function(_$FeatureFlagsImpl) then) =
      __$$FeatureFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? showPortfolioTab,
      bool? enableContactForm,
      bool? showPodcastGenre,
      String? customStartTab});
}

/// @nodoc
class __$$FeatureFlagsImplCopyWithImpl<$Res>
    extends _$FeatureFlagsCopyWithImpl<$Res, _$FeatureFlagsImpl>
    implements _$$FeatureFlagsImplCopyWith<$Res> {
  __$$FeatureFlagsImplCopyWithImpl(
      _$FeatureFlagsImpl _value, $Res Function(_$FeatureFlagsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showPortfolioTab = freezed,
    Object? enableContactForm = freezed,
    Object? showPodcastGenre = freezed,
    Object? customStartTab = freezed,
  }) {
    return _then(_$FeatureFlagsImpl(
      showPortfolioTab: freezed == showPortfolioTab
          ? _value.showPortfolioTab
          : showPortfolioTab // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableContactForm: freezed == enableContactForm
          ? _value.enableContactForm
          : enableContactForm // ignore: cast_nullable_to_non_nullable
              as bool?,
      showPodcastGenre: freezed == showPodcastGenre
          ? _value.showPodcastGenre
          : showPodcastGenre // ignore: cast_nullable_to_non_nullable
              as bool?,
      customStartTab: freezed == customStartTab
          ? _value.customStartTab
          : customStartTab // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeatureFlagsImpl implements _FeatureFlags {
  const _$FeatureFlagsImpl(
      {this.showPortfolioTab,
      this.enableContactForm,
      this.showPodcastGenre,
      this.customStartTab});

  factory _$FeatureFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeatureFlagsImplFromJson(json);

  @override
  final bool? showPortfolioTab;
  @override
  final bool? enableContactForm;
  @override
  final bool? showPodcastGenre;
  @override
  final String? customStartTab;

  @override
  String toString() {
    return 'FeatureFlags(showPortfolioTab: $showPortfolioTab, enableContactForm: $enableContactForm, showPodcastGenre: $showPodcastGenre, customStartTab: $customStartTab)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureFlagsImpl &&
            (identical(other.showPortfolioTab, showPortfolioTab) ||
                other.showPortfolioTab == showPortfolioTab) &&
            (identical(other.enableContactForm, enableContactForm) ||
                other.enableContactForm == enableContactForm) &&
            (identical(other.showPodcastGenre, showPodcastGenre) ||
                other.showPodcastGenre == showPodcastGenre) &&
            (identical(other.customStartTab, customStartTab) ||
                other.customStartTab == customStartTab));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, showPortfolioTab,
      enableContactForm, showPodcastGenre, customStartTab);

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      __$$FeatureFlagsImplCopyWithImpl<_$FeatureFlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureFlagsImplToJson(
      this,
    );
  }
}

abstract class _FeatureFlags implements FeatureFlags {
  const factory _FeatureFlags(
      {final bool? showPortfolioTab,
      final bool? enableContactForm,
      final bool? showPodcastGenre,
      final String? customStartTab}) = _$FeatureFlagsImpl;

  factory _FeatureFlags.fromJson(Map<String, dynamic> json) =
      _$FeatureFlagsImpl.fromJson;

  @override
  bool? get showPortfolioTab;
  @override
  bool? get enableContactForm;
  @override
  bool? get showPodcastGenre;
  @override
  String? get customStartTab;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
