// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppEntity {

 bool get init; String get initDate; String get lastDate; bool get migratedV1;
/// Create a copy of AppEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppEntityCopyWith<AppEntity> get copyWith => _$AppEntityCopyWithImpl<AppEntity>(this as AppEntity, _$identity);

  /// Serializes this AppEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppEntity&&(identical(other.init, init) || other.init == init)&&(identical(other.initDate, initDate) || other.initDate == initDate)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate)&&(identical(other.migratedV1, migratedV1) || other.migratedV1 == migratedV1));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,init,initDate,lastDate,migratedV1);

@override
String toString() {
  return 'AppEntity(init: $init, initDate: $initDate, lastDate: $lastDate, migratedV1: $migratedV1)';
}


}

/// @nodoc
abstract mixin class $AppEntityCopyWith<$Res>  {
  factory $AppEntityCopyWith(AppEntity value, $Res Function(AppEntity) _then) = _$AppEntityCopyWithImpl;
@useResult
$Res call({
 bool init, String initDate, String lastDate, bool migratedV1
});




}
/// @nodoc
class _$AppEntityCopyWithImpl<$Res>
    implements $AppEntityCopyWith<$Res> {
  _$AppEntityCopyWithImpl(this._self, this._then);

  final AppEntity _self;
  final $Res Function(AppEntity) _then;

/// Create a copy of AppEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? init = null,Object? initDate = null,Object? lastDate = null,Object? migratedV1 = null,}) {
  return _then(_self.copyWith(
init: null == init ? _self.init : init // ignore: cast_nullable_to_non_nullable
as bool,initDate: null == initDate ? _self.initDate : initDate // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as String,migratedV1: null == migratedV1 ? _self.migratedV1 : migratedV1 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppEntity].
extension AppEntityPatterns on AppEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppEntity value)  $default,){
final _that = this;
switch (_that) {
case _AppEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AppEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool init,  String initDate,  String lastDate,  bool migratedV1)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppEntity() when $default != null:
return $default(_that.init,_that.initDate,_that.lastDate,_that.migratedV1);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool init,  String initDate,  String lastDate,  bool migratedV1)  $default,) {final _that = this;
switch (_that) {
case _AppEntity():
return $default(_that.init,_that.initDate,_that.lastDate,_that.migratedV1);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool init,  String initDate,  String lastDate,  bool migratedV1)?  $default,) {final _that = this;
switch (_that) {
case _AppEntity() when $default != null:
return $default(_that.init,_that.initDate,_that.lastDate,_that.migratedV1);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppEntity implements AppEntity {
  const _AppEntity({this.init = false, this.initDate = '', this.lastDate = '', this.migratedV1 = false});
  factory _AppEntity.fromJson(Map<String, dynamic> json) => _$AppEntityFromJson(json);

@override@JsonKey() final  bool init;
@override@JsonKey() final  String initDate;
@override@JsonKey() final  String lastDate;
@override@JsonKey() final  bool migratedV1;

/// Create a copy of AppEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppEntityCopyWith<_AppEntity> get copyWith => __$AppEntityCopyWithImpl<_AppEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppEntity&&(identical(other.init, init) || other.init == init)&&(identical(other.initDate, initDate) || other.initDate == initDate)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate)&&(identical(other.migratedV1, migratedV1) || other.migratedV1 == migratedV1));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,init,initDate,lastDate,migratedV1);

@override
String toString() {
  return 'AppEntity(init: $init, initDate: $initDate, lastDate: $lastDate, migratedV1: $migratedV1)';
}


}

/// @nodoc
abstract mixin class _$AppEntityCopyWith<$Res> implements $AppEntityCopyWith<$Res> {
  factory _$AppEntityCopyWith(_AppEntity value, $Res Function(_AppEntity) _then) = __$AppEntityCopyWithImpl;
@override @useResult
$Res call({
 bool init, String initDate, String lastDate, bool migratedV1
});




}
/// @nodoc
class __$AppEntityCopyWithImpl<$Res>
    implements _$AppEntityCopyWith<$Res> {
  __$AppEntityCopyWithImpl(this._self, this._then);

  final _AppEntity _self;
  final $Res Function(_AppEntity) _then;

/// Create a copy of AppEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? init = null,Object? initDate = null,Object? lastDate = null,Object? migratedV1 = null,}) {
  return _then(_AppEntity(
init: null == init ? _self.init : init // ignore: cast_nullable_to_non_nullable
as bool,initDate: null == initDate ? _self.initDate : initDate // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as String,migratedV1: null == migratedV1 ? _self.migratedV1 : migratedV1 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
