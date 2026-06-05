// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitSuggestion {

 String get title; String get description; List<String> get suggestedWeekdays;
/// Create a copy of HabitSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitSuggestionCopyWith<HabitSuggestion> get copyWith => _$HabitSuggestionCopyWithImpl<HabitSuggestion>(this as HabitSuggestion, _$identity);

  /// Serializes this HabitSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.suggestedWeekdays, suggestedWeekdays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(suggestedWeekdays));

@override
String toString() {
  return 'HabitSuggestion(title: $title, description: $description, suggestedWeekdays: $suggestedWeekdays)';
}


}

/// @nodoc
abstract mixin class $HabitSuggestionCopyWith<$Res>  {
  factory $HabitSuggestionCopyWith(HabitSuggestion value, $Res Function(HabitSuggestion) _then) = _$HabitSuggestionCopyWithImpl;
@useResult
$Res call({
 String title, String description, List<String> suggestedWeekdays
});




}
/// @nodoc
class _$HabitSuggestionCopyWithImpl<$Res>
    implements $HabitSuggestionCopyWith<$Res> {
  _$HabitSuggestionCopyWithImpl(this._self, this._then);

  final HabitSuggestion _self;
  final $Res Function(HabitSuggestion) _then;

/// Create a copy of HabitSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? suggestedWeekdays = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,suggestedWeekdays: null == suggestedWeekdays ? _self.suggestedWeekdays : suggestedWeekdays // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitSuggestion].
extension HabitSuggestionPatterns on HabitSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _HabitSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _HabitSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  List<String> suggestedWeekdays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitSuggestion() when $default != null:
return $default(_that.title,_that.description,_that.suggestedWeekdays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  List<String> suggestedWeekdays)  $default,) {final _that = this;
switch (_that) {
case _HabitSuggestion():
return $default(_that.title,_that.description,_that.suggestedWeekdays);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  List<String> suggestedWeekdays)?  $default,) {final _that = this;
switch (_that) {
case _HabitSuggestion() when $default != null:
return $default(_that.title,_that.description,_that.suggestedWeekdays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitSuggestion implements HabitSuggestion {
  const _HabitSuggestion({required this.title, required this.description, final  List<String> suggestedWeekdays = const <String>[]}): _suggestedWeekdays = suggestedWeekdays;
  factory _HabitSuggestion.fromJson(Map<String, dynamic> json) => _$HabitSuggestionFromJson(json);

@override final  String title;
@override final  String description;
 final  List<String> _suggestedWeekdays;
@override@JsonKey() List<String> get suggestedWeekdays {
  if (_suggestedWeekdays is EqualUnmodifiableListView) return _suggestedWeekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedWeekdays);
}


/// Create a copy of HabitSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitSuggestionCopyWith<_HabitSuggestion> get copyWith => __$HabitSuggestionCopyWithImpl<_HabitSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._suggestedWeekdays, _suggestedWeekdays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(_suggestedWeekdays));

@override
String toString() {
  return 'HabitSuggestion(title: $title, description: $description, suggestedWeekdays: $suggestedWeekdays)';
}


}

/// @nodoc
abstract mixin class _$HabitSuggestionCopyWith<$Res> implements $HabitSuggestionCopyWith<$Res> {
  factory _$HabitSuggestionCopyWith(_HabitSuggestion value, $Res Function(_HabitSuggestion) _then) = __$HabitSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, List<String> suggestedWeekdays
});




}
/// @nodoc
class __$HabitSuggestionCopyWithImpl<$Res>
    implements _$HabitSuggestionCopyWith<$Res> {
  __$HabitSuggestionCopyWithImpl(this._self, this._then);

  final _HabitSuggestion _self;
  final $Res Function(_HabitSuggestion) _then;

/// Create a copy of HabitSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? suggestedWeekdays = null,}) {
  return _then(_HabitSuggestion(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,suggestedWeekdays: null == suggestedWeekdays ? _self._suggestedWeekdays : suggestedWeekdays // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
