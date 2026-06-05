// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitStatsEntity {

 int get done; int get notDone; int get created; int get suspended; int get inProgress;
/// Create a copy of HabitStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitStatsEntityCopyWith<HabitStatsEntity> get copyWith => _$HabitStatsEntityCopyWithImpl<HabitStatsEntity>(this as HabitStatsEntity, _$identity);

  /// Serializes this HabitStatsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitStatsEntity&&(identical(other.done, done) || other.done == done)&&(identical(other.notDone, notDone) || other.notDone == notDone)&&(identical(other.created, created) || other.created == created)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,done,notDone,created,suspended,inProgress);

@override
String toString() {
  return 'HabitStatsEntity(done: $done, notDone: $notDone, created: $created, suspended: $suspended, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class $HabitStatsEntityCopyWith<$Res>  {
  factory $HabitStatsEntityCopyWith(HabitStatsEntity value, $Res Function(HabitStatsEntity) _then) = _$HabitStatsEntityCopyWithImpl;
@useResult
$Res call({
 int done, int notDone, int created, int suspended, int inProgress
});




}
/// @nodoc
class _$HabitStatsEntityCopyWithImpl<$Res>
    implements $HabitStatsEntityCopyWith<$Res> {
  _$HabitStatsEntityCopyWithImpl(this._self, this._then);

  final HabitStatsEntity _self;
  final $Res Function(HabitStatsEntity) _then;

/// Create a copy of HabitStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? done = null,Object? notDone = null,Object? created = null,Object? suspended = null,Object? inProgress = null,}) {
  return _then(_self.copyWith(
done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,notDone: null == notDone ? _self.notDone : notDone // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitStatsEntity].
extension HabitStatsEntityPatterns on HabitStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _HabitStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HabitStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int done,  int notDone,  int created,  int suspended,  int inProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitStatsEntity() when $default != null:
return $default(_that.done,_that.notDone,_that.created,_that.suspended,_that.inProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int done,  int notDone,  int created,  int suspended,  int inProgress)  $default,) {final _that = this;
switch (_that) {
case _HabitStatsEntity():
return $default(_that.done,_that.notDone,_that.created,_that.suspended,_that.inProgress);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int done,  int notDone,  int created,  int suspended,  int inProgress)?  $default,) {final _that = this;
switch (_that) {
case _HabitStatsEntity() when $default != null:
return $default(_that.done,_that.notDone,_that.created,_that.suspended,_that.inProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitStatsEntity implements HabitStatsEntity {
  const _HabitStatsEntity({required this.done, required this.notDone, required this.created, required this.suspended, this.inProgress = 0});
  factory _HabitStatsEntity.fromJson(Map<String, dynamic> json) => _$HabitStatsEntityFromJson(json);

@override final  int done;
@override final  int notDone;
@override final  int created;
@override final  int suspended;
@override@JsonKey() final  int inProgress;

/// Create a copy of HabitStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitStatsEntityCopyWith<_HabitStatsEntity> get copyWith => __$HabitStatsEntityCopyWithImpl<_HabitStatsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitStatsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitStatsEntity&&(identical(other.done, done) || other.done == done)&&(identical(other.notDone, notDone) || other.notDone == notDone)&&(identical(other.created, created) || other.created == created)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,done,notDone,created,suspended,inProgress);

@override
String toString() {
  return 'HabitStatsEntity(done: $done, notDone: $notDone, created: $created, suspended: $suspended, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class _$HabitStatsEntityCopyWith<$Res> implements $HabitStatsEntityCopyWith<$Res> {
  factory _$HabitStatsEntityCopyWith(_HabitStatsEntity value, $Res Function(_HabitStatsEntity) _then) = __$HabitStatsEntityCopyWithImpl;
@override @useResult
$Res call({
 int done, int notDone, int created, int suspended, int inProgress
});




}
/// @nodoc
class __$HabitStatsEntityCopyWithImpl<$Res>
    implements _$HabitStatsEntityCopyWith<$Res> {
  __$HabitStatsEntityCopyWithImpl(this._self, this._then);

  final _HabitStatsEntity _self;
  final $Res Function(_HabitStatsEntity) _then;

/// Create a copy of HabitStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? done = null,Object? notDone = null,Object? created = null,Object? suspended = null,Object? inProgress = null,}) {
  return _then(_HabitStatsEntity(
done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,notDone: null == notDone ? _self.notDone : notDone // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
