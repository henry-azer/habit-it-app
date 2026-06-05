// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitCategory {

 String get id; String get name; String get iconName;// FontAwesome icon name
 String get colorHex;
/// Create a copy of HabitCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCategoryCopyWith<HabitCategory> get copyWith => _$HabitCategoryCopyWithImpl<HabitCategory>(this as HabitCategory, _$identity);

  /// Serializes this HabitCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconName,colorHex);

@override
String toString() {
  return 'HabitCategory(id: $id, name: $name, iconName: $iconName, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class $HabitCategoryCopyWith<$Res>  {
  factory $HabitCategoryCopyWith(HabitCategory value, $Res Function(HabitCategory) _then) = _$HabitCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String iconName, String colorHex
});




}
/// @nodoc
class _$HabitCategoryCopyWithImpl<$Res>
    implements $HabitCategoryCopyWith<$Res> {
  _$HabitCategoryCopyWithImpl(this._self, this._then);

  final HabitCategory _self;
  final $Res Function(HabitCategory) _then;

/// Create a copy of HabitCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconName = null,Object? colorHex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitCategory].
extension HabitCategoryPatterns on HabitCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitCategory value)  $default,){
final _that = this;
switch (_that) {
case _HabitCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitCategory value)?  $default,){
final _that = this;
switch (_that) {
case _HabitCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String iconName,  String colorHex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitCategory() when $default != null:
return $default(_that.id,_that.name,_that.iconName,_that.colorHex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String iconName,  String colorHex)  $default,) {final _that = this;
switch (_that) {
case _HabitCategory():
return $default(_that.id,_that.name,_that.iconName,_that.colorHex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String iconName,  String colorHex)?  $default,) {final _that = this;
switch (_that) {
case _HabitCategory() when $default != null:
return $default(_that.id,_that.name,_that.iconName,_that.colorHex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitCategory implements HabitCategory {
  const _HabitCategory({required this.id, required this.name, required this.iconName, required this.colorHex});
  factory _HabitCategory.fromJson(Map<String, dynamic> json) => _$HabitCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String iconName;
// FontAwesome icon name
@override final  String colorHex;

/// Create a copy of HabitCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCategoryCopyWith<_HabitCategory> get copyWith => __$HabitCategoryCopyWithImpl<_HabitCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconName,colorHex);

@override
String toString() {
  return 'HabitCategory(id: $id, name: $name, iconName: $iconName, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$HabitCategoryCopyWith<$Res> implements $HabitCategoryCopyWith<$Res> {
  factory _$HabitCategoryCopyWith(_HabitCategory value, $Res Function(_HabitCategory) _then) = __$HabitCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String iconName, String colorHex
});




}
/// @nodoc
class __$HabitCategoryCopyWithImpl<$Res>
    implements _$HabitCategoryCopyWith<$Res> {
  __$HabitCategoryCopyWithImpl(this._self, this._then);

  final _HabitCategory _self;
  final $Res Function(_HabitCategory) _then;

/// Create a copy of HabitCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconName = null,Object? colorHex = null,}) {
  return _then(_HabitCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
