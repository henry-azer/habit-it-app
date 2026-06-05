// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsModel {

 String get themeMode;// 'system' | 'light' | 'dark'
 String get accentColorHex; String? get localeCode;// null → system
 bool get notificationsEnabled; bool get dailySummaryEnabled; String get dailySummaryHhmm;@_HabitScheduleConverter() HabitSchedule get defaultSchedule; String? get defaultReminderHhmm; bool get biometricEnabled; bool get aiEnabled; String get aiModel; LandingMode get defaultLanding; bool get coachPrivacyAcknowledged;
/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsModelCopyWith<SettingsModel> get copyWith => _$SettingsModelCopyWithImpl<SettingsModel>(this as SettingsModel, _$identity);

  /// Serializes this SettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsModel&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.accentColorHex, accentColorHex) || other.accentColorHex == accentColorHex)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailySummaryEnabled, dailySummaryEnabled) || other.dailySummaryEnabled == dailySummaryEnabled)&&(identical(other.dailySummaryHhmm, dailySummaryHhmm) || other.dailySummaryHhmm == dailySummaryHhmm)&&(identical(other.defaultSchedule, defaultSchedule) || other.defaultSchedule == defaultSchedule)&&(identical(other.defaultReminderHhmm, defaultReminderHhmm) || other.defaultReminderHhmm == defaultReminderHhmm)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.aiEnabled, aiEnabled) || other.aiEnabled == aiEnabled)&&(identical(other.aiModel, aiModel) || other.aiModel == aiModel)&&(identical(other.defaultLanding, defaultLanding) || other.defaultLanding == defaultLanding)&&(identical(other.coachPrivacyAcknowledged, coachPrivacyAcknowledged) || other.coachPrivacyAcknowledged == coachPrivacyAcknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,accentColorHex,localeCode,notificationsEnabled,dailySummaryEnabled,dailySummaryHhmm,defaultSchedule,defaultReminderHhmm,biometricEnabled,aiEnabled,aiModel,defaultLanding,coachPrivacyAcknowledged);

@override
String toString() {
  return 'SettingsModel(themeMode: $themeMode, accentColorHex: $accentColorHex, localeCode: $localeCode, notificationsEnabled: $notificationsEnabled, dailySummaryEnabled: $dailySummaryEnabled, dailySummaryHhmm: $dailySummaryHhmm, defaultSchedule: $defaultSchedule, defaultReminderHhmm: $defaultReminderHhmm, biometricEnabled: $biometricEnabled, aiEnabled: $aiEnabled, aiModel: $aiModel, defaultLanding: $defaultLanding, coachPrivacyAcknowledged: $coachPrivacyAcknowledged)';
}


}

/// @nodoc
abstract mixin class $SettingsModelCopyWith<$Res>  {
  factory $SettingsModelCopyWith(SettingsModel value, $Res Function(SettingsModel) _then) = _$SettingsModelCopyWithImpl;
@useResult
$Res call({
 String themeMode, String accentColorHex, String? localeCode, bool notificationsEnabled, bool dailySummaryEnabled, String dailySummaryHhmm,@_HabitScheduleConverter() HabitSchedule defaultSchedule, String? defaultReminderHhmm, bool biometricEnabled, bool aiEnabled, String aiModel, LandingMode defaultLanding, bool coachPrivacyAcknowledged
});


$HabitScheduleCopyWith<$Res> get defaultSchedule;

}
/// @nodoc
class _$SettingsModelCopyWithImpl<$Res>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._self, this._then);

  final SettingsModel _self;
  final $Res Function(SettingsModel) _then;

/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? accentColorHex = null,Object? localeCode = freezed,Object? notificationsEnabled = null,Object? dailySummaryEnabled = null,Object? dailySummaryHhmm = null,Object? defaultSchedule = null,Object? defaultReminderHhmm = freezed,Object? biometricEnabled = null,Object? aiEnabled = null,Object? aiModel = null,Object? defaultLanding = null,Object? coachPrivacyAcknowledged = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,accentColorHex: null == accentColorHex ? _self.accentColorHex : accentColorHex // ignore: cast_nullable_to_non_nullable
as String,localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySummaryEnabled: null == dailySummaryEnabled ? _self.dailySummaryEnabled : dailySummaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySummaryHhmm: null == dailySummaryHhmm ? _self.dailySummaryHhmm : dailySummaryHhmm // ignore: cast_nullable_to_non_nullable
as String,defaultSchedule: null == defaultSchedule ? _self.defaultSchedule : defaultSchedule // ignore: cast_nullable_to_non_nullable
as HabitSchedule,defaultReminderHhmm: freezed == defaultReminderHhmm ? _self.defaultReminderHhmm : defaultReminderHhmm // ignore: cast_nullable_to_non_nullable
as String?,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,aiEnabled: null == aiEnabled ? _self.aiEnabled : aiEnabled // ignore: cast_nullable_to_non_nullable
as bool,aiModel: null == aiModel ? _self.aiModel : aiModel // ignore: cast_nullable_to_non_nullable
as String,defaultLanding: null == defaultLanding ? _self.defaultLanding : defaultLanding // ignore: cast_nullable_to_non_nullable
as LandingMode,coachPrivacyAcknowledged: null == coachPrivacyAcknowledged ? _self.coachPrivacyAcknowledged : coachPrivacyAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitScheduleCopyWith<$Res> get defaultSchedule {
  
  return $HabitScheduleCopyWith<$Res>(_self.defaultSchedule, (value) {
    return _then(_self.copyWith(defaultSchedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsModel].
extension SettingsModelPatterns on SettingsModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _SettingsModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeMode,  String accentColorHex,  String? localeCode,  bool notificationsEnabled,  bool dailySummaryEnabled,  String dailySummaryHhmm, @_HabitScheduleConverter()  HabitSchedule defaultSchedule,  String? defaultReminderHhmm,  bool biometricEnabled,  bool aiEnabled,  String aiModel,  LandingMode defaultLanding,  bool coachPrivacyAcknowledged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsModel() when $default != null:
return $default(_that.themeMode,_that.accentColorHex,_that.localeCode,_that.notificationsEnabled,_that.dailySummaryEnabled,_that.dailySummaryHhmm,_that.defaultSchedule,_that.defaultReminderHhmm,_that.biometricEnabled,_that.aiEnabled,_that.aiModel,_that.defaultLanding,_that.coachPrivacyAcknowledged);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeMode,  String accentColorHex,  String? localeCode,  bool notificationsEnabled,  bool dailySummaryEnabled,  String dailySummaryHhmm, @_HabitScheduleConverter()  HabitSchedule defaultSchedule,  String? defaultReminderHhmm,  bool biometricEnabled,  bool aiEnabled,  String aiModel,  LandingMode defaultLanding,  bool coachPrivacyAcknowledged)  $default,) {final _that = this;
switch (_that) {
case _SettingsModel():
return $default(_that.themeMode,_that.accentColorHex,_that.localeCode,_that.notificationsEnabled,_that.dailySummaryEnabled,_that.dailySummaryHhmm,_that.defaultSchedule,_that.defaultReminderHhmm,_that.biometricEnabled,_that.aiEnabled,_that.aiModel,_that.defaultLanding,_that.coachPrivacyAcknowledged);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeMode,  String accentColorHex,  String? localeCode,  bool notificationsEnabled,  bool dailySummaryEnabled,  String dailySummaryHhmm, @_HabitScheduleConverter()  HabitSchedule defaultSchedule,  String? defaultReminderHhmm,  bool biometricEnabled,  bool aiEnabled,  String aiModel,  LandingMode defaultLanding,  bool coachPrivacyAcknowledged)?  $default,) {final _that = this;
switch (_that) {
case _SettingsModel() when $default != null:
return $default(_that.themeMode,_that.accentColorHex,_that.localeCode,_that.notificationsEnabled,_that.dailySummaryEnabled,_that.dailySummaryHhmm,_that.defaultSchedule,_that.defaultReminderHhmm,_that.biometricEnabled,_that.aiEnabled,_that.aiModel,_that.defaultLanding,_that.coachPrivacyAcknowledged);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsModel implements SettingsModel {
  const _SettingsModel({this.themeMode = 'system', this.accentColorHex = '#00A36C', this.localeCode, this.notificationsEnabled = true, this.dailySummaryEnabled = false, this.dailySummaryHhmm = '08:00', @_HabitScheduleConverter() this.defaultSchedule = const HabitSchedule.daily(), this.defaultReminderHhmm, this.biometricEnabled = false, this.aiEnabled = false, this.aiModel = 'llama-3.3-70b-versatile', this.defaultLanding = LandingMode.habits, this.coachPrivacyAcknowledged = false});
  factory _SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);

@override@JsonKey() final  String themeMode;
// 'system' | 'light' | 'dark'
@override@JsonKey() final  String accentColorHex;
@override final  String? localeCode;
// null → system
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool dailySummaryEnabled;
@override@JsonKey() final  String dailySummaryHhmm;
@override@JsonKey()@_HabitScheduleConverter() final  HabitSchedule defaultSchedule;
@override final  String? defaultReminderHhmm;
@override@JsonKey() final  bool biometricEnabled;
@override@JsonKey() final  bool aiEnabled;
@override@JsonKey() final  String aiModel;
@override@JsonKey() final  LandingMode defaultLanding;
@override@JsonKey() final  bool coachPrivacyAcknowledged;

/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsModelCopyWith<_SettingsModel> get copyWith => __$SettingsModelCopyWithImpl<_SettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsModel&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.accentColorHex, accentColorHex) || other.accentColorHex == accentColorHex)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailySummaryEnabled, dailySummaryEnabled) || other.dailySummaryEnabled == dailySummaryEnabled)&&(identical(other.dailySummaryHhmm, dailySummaryHhmm) || other.dailySummaryHhmm == dailySummaryHhmm)&&(identical(other.defaultSchedule, defaultSchedule) || other.defaultSchedule == defaultSchedule)&&(identical(other.defaultReminderHhmm, defaultReminderHhmm) || other.defaultReminderHhmm == defaultReminderHhmm)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.aiEnabled, aiEnabled) || other.aiEnabled == aiEnabled)&&(identical(other.aiModel, aiModel) || other.aiModel == aiModel)&&(identical(other.defaultLanding, defaultLanding) || other.defaultLanding == defaultLanding)&&(identical(other.coachPrivacyAcknowledged, coachPrivacyAcknowledged) || other.coachPrivacyAcknowledged == coachPrivacyAcknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,accentColorHex,localeCode,notificationsEnabled,dailySummaryEnabled,dailySummaryHhmm,defaultSchedule,defaultReminderHhmm,biometricEnabled,aiEnabled,aiModel,defaultLanding,coachPrivacyAcknowledged);

@override
String toString() {
  return 'SettingsModel(themeMode: $themeMode, accentColorHex: $accentColorHex, localeCode: $localeCode, notificationsEnabled: $notificationsEnabled, dailySummaryEnabled: $dailySummaryEnabled, dailySummaryHhmm: $dailySummaryHhmm, defaultSchedule: $defaultSchedule, defaultReminderHhmm: $defaultReminderHhmm, biometricEnabled: $biometricEnabled, aiEnabled: $aiEnabled, aiModel: $aiModel, defaultLanding: $defaultLanding, coachPrivacyAcknowledged: $coachPrivacyAcknowledged)';
}


}

/// @nodoc
abstract mixin class _$SettingsModelCopyWith<$Res> implements $SettingsModelCopyWith<$Res> {
  factory _$SettingsModelCopyWith(_SettingsModel value, $Res Function(_SettingsModel) _then) = __$SettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String themeMode, String accentColorHex, String? localeCode, bool notificationsEnabled, bool dailySummaryEnabled, String dailySummaryHhmm,@_HabitScheduleConverter() HabitSchedule defaultSchedule, String? defaultReminderHhmm, bool biometricEnabled, bool aiEnabled, String aiModel, LandingMode defaultLanding, bool coachPrivacyAcknowledged
});


@override $HabitScheduleCopyWith<$Res> get defaultSchedule;

}
/// @nodoc
class __$SettingsModelCopyWithImpl<$Res>
    implements _$SettingsModelCopyWith<$Res> {
  __$SettingsModelCopyWithImpl(this._self, this._then);

  final _SettingsModel _self;
  final $Res Function(_SettingsModel) _then;

/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? accentColorHex = null,Object? localeCode = freezed,Object? notificationsEnabled = null,Object? dailySummaryEnabled = null,Object? dailySummaryHhmm = null,Object? defaultSchedule = null,Object? defaultReminderHhmm = freezed,Object? biometricEnabled = null,Object? aiEnabled = null,Object? aiModel = null,Object? defaultLanding = null,Object? coachPrivacyAcknowledged = null,}) {
  return _then(_SettingsModel(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,accentColorHex: null == accentColorHex ? _self.accentColorHex : accentColorHex // ignore: cast_nullable_to_non_nullable
as String,localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySummaryEnabled: null == dailySummaryEnabled ? _self.dailySummaryEnabled : dailySummaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySummaryHhmm: null == dailySummaryHhmm ? _self.dailySummaryHhmm : dailySummaryHhmm // ignore: cast_nullable_to_non_nullable
as String,defaultSchedule: null == defaultSchedule ? _self.defaultSchedule : defaultSchedule // ignore: cast_nullable_to_non_nullable
as HabitSchedule,defaultReminderHhmm: freezed == defaultReminderHhmm ? _self.defaultReminderHhmm : defaultReminderHhmm // ignore: cast_nullable_to_non_nullable
as String?,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,aiEnabled: null == aiEnabled ? _self.aiEnabled : aiEnabled // ignore: cast_nullable_to_non_nullable
as bool,aiModel: null == aiModel ? _self.aiModel : aiModel // ignore: cast_nullable_to_non_nullable
as String,defaultLanding: null == defaultLanding ? _self.defaultLanding : defaultLanding // ignore: cast_nullable_to_non_nullable
as LandingMode,coachPrivacyAcknowledged: null == coachPrivacyAcknowledged ? _self.coachPrivacyAcknowledged : coachPrivacyAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitScheduleCopyWith<$Res> get defaultSchedule {
  
  return $HabitScheduleCopyWith<$Res>(_self.defaultSchedule, (value) {
    return _then(_self.copyWith(defaultSchedule: value));
  });
}
}

// dart format on
