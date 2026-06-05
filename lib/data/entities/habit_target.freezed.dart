// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitTarget {

 int get targetCount; String get unit;
/// Create a copy of HabitTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitTargetCopyWith<HabitTarget> get copyWith => _$HabitTargetCopyWithImpl<HabitTarget>(this as HabitTarget, _$identity);

  /// Serializes this HabitTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitTarget&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetCount,unit);

@override
String toString() {
  return 'HabitTarget(targetCount: $targetCount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $HabitTargetCopyWith<$Res>  {
  factory $HabitTargetCopyWith(HabitTarget value, $Res Function(HabitTarget) _then) = _$HabitTargetCopyWithImpl;
@useResult
$Res call({
 int targetCount, String unit
});




}
/// @nodoc
class _$HabitTargetCopyWithImpl<$Res>
    implements $HabitTargetCopyWith<$Res> {
  _$HabitTargetCopyWithImpl(this._self, this._then);

  final HabitTarget _self;
  final $Res Function(HabitTarget) _then;

/// Create a copy of HabitTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetCount = null,Object? unit = null,}) {
  return _then(_self.copyWith(
targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitTarget].
extension HabitTargetPatterns on HabitTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitTarget value)  $default,){
final _that = this;
switch (_that) {
case _HabitTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitTarget value)?  $default,){
final _that = this;
switch (_that) {
case _HabitTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int targetCount,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitTarget() when $default != null:
return $default(_that.targetCount,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int targetCount,  String unit)  $default,) {final _that = this;
switch (_that) {
case _HabitTarget():
return $default(_that.targetCount,_that.unit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int targetCount,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _HabitTarget() when $default != null:
return $default(_that.targetCount,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitTarget implements HabitTarget {
  const _HabitTarget({required this.targetCount, required this.unit});
  factory _HabitTarget.fromJson(Map<String, dynamic> json) => _$HabitTargetFromJson(json);

@override final  int targetCount;
@override final  String unit;

/// Create a copy of HabitTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitTargetCopyWith<_HabitTarget> get copyWith => __$HabitTargetCopyWithImpl<_HabitTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitTarget&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetCount,unit);

@override
String toString() {
  return 'HabitTarget(targetCount: $targetCount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$HabitTargetCopyWith<$Res> implements $HabitTargetCopyWith<$Res> {
  factory _$HabitTargetCopyWith(_HabitTarget value, $Res Function(_HabitTarget) _then) = __$HabitTargetCopyWithImpl;
@override @useResult
$Res call({
 int targetCount, String unit
});




}
/// @nodoc
class __$HabitTargetCopyWithImpl<$Res>
    implements _$HabitTargetCopyWith<$Res> {
  __$HabitTargetCopyWithImpl(this._self, this._then);

  final _HabitTarget _self;
  final $Res Function(_HabitTarget) _then;

/// Create a copy of HabitTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetCount = null,Object? unit = null,}) {
  return _then(_HabitTarget(
targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
