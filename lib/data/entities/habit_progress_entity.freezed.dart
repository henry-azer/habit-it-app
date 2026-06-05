// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_progress_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitProgressEntity {

 String get habitId; int get day; int get count;
/// Create a copy of HabitProgressEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitProgressEntityCopyWith<HabitProgressEntity> get copyWith => _$HabitProgressEntityCopyWithImpl<HabitProgressEntity>(this as HabitProgressEntity, _$identity);

  /// Serializes this HabitProgressEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitProgressEntity&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.day, day) || other.day == day)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,day,count);

@override
String toString() {
  return 'HabitProgressEntity(habitId: $habitId, day: $day, count: $count)';
}


}

/// @nodoc
abstract mixin class $HabitProgressEntityCopyWith<$Res>  {
  factory $HabitProgressEntityCopyWith(HabitProgressEntity value, $Res Function(HabitProgressEntity) _then) = _$HabitProgressEntityCopyWithImpl;
@useResult
$Res call({
 String habitId, int day, int count
});




}
/// @nodoc
class _$HabitProgressEntityCopyWithImpl<$Res>
    implements $HabitProgressEntityCopyWith<$Res> {
  _$HabitProgressEntityCopyWithImpl(this._self, this._then);

  final HabitProgressEntity _self;
  final $Res Function(HabitProgressEntity) _then;

/// Create a copy of HabitProgressEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? day = null,Object? count = null,}) {
  return _then(_self.copyWith(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitProgressEntity].
extension HabitProgressEntityPatterns on HabitProgressEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitProgressEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitProgressEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitProgressEntity value)  $default,){
final _that = this;
switch (_that) {
case _HabitProgressEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitProgressEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HabitProgressEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId,  int day,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitProgressEntity() when $default != null:
return $default(_that.habitId,_that.day,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId,  int day,  int count)  $default,) {final _that = this;
switch (_that) {
case _HabitProgressEntity():
return $default(_that.habitId,_that.day,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId,  int day,  int count)?  $default,) {final _that = this;
switch (_that) {
case _HabitProgressEntity() when $default != null:
return $default(_that.habitId,_that.day,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitProgressEntity implements HabitProgressEntity {
  const _HabitProgressEntity({required this.habitId, required this.day, required this.count});
  factory _HabitProgressEntity.fromJson(Map<String, dynamic> json) => _$HabitProgressEntityFromJson(json);

@override final  String habitId;
@override final  int day;
@override final  int count;

/// Create a copy of HabitProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitProgressEntityCopyWith<_HabitProgressEntity> get copyWith => __$HabitProgressEntityCopyWithImpl<_HabitProgressEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitProgressEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitProgressEntity&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.day, day) || other.day == day)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,day,count);

@override
String toString() {
  return 'HabitProgressEntity(habitId: $habitId, day: $day, count: $count)';
}


}

/// @nodoc
abstract mixin class _$HabitProgressEntityCopyWith<$Res> implements $HabitProgressEntityCopyWith<$Res> {
  factory _$HabitProgressEntityCopyWith(_HabitProgressEntity value, $Res Function(_HabitProgressEntity) _then) = __$HabitProgressEntityCopyWithImpl;
@override @useResult
$Res call({
 String habitId, int day, int count
});




}
/// @nodoc
class __$HabitProgressEntityCopyWithImpl<$Res>
    implements _$HabitProgressEntityCopyWith<$Res> {
  __$HabitProgressEntityCopyWithImpl(this._self, this._then);

  final _HabitProgressEntity _self;
  final $Res Function(_HabitProgressEntity) _then;

/// Create a copy of HabitProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? day = null,Object? count = null,}) {
  return _then(_HabitProgressEntity(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
