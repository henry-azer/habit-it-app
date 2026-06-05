// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitNote {

 String get habitId; DateTime get date; String get text;
/// Create a copy of HabitNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitNoteCopyWith<HabitNote> get copyWith => _$HabitNoteCopyWithImpl<HabitNote>(this as HabitNote, _$identity);

  /// Serializes this HabitNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitNote&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.date, date) || other.date == date)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,date,text);

@override
String toString() {
  return 'HabitNote(habitId: $habitId, date: $date, text: $text)';
}


}

/// @nodoc
abstract mixin class $HabitNoteCopyWith<$Res>  {
  factory $HabitNoteCopyWith(HabitNote value, $Res Function(HabitNote) _then) = _$HabitNoteCopyWithImpl;
@useResult
$Res call({
 String habitId, DateTime date, String text
});




}
/// @nodoc
class _$HabitNoteCopyWithImpl<$Res>
    implements $HabitNoteCopyWith<$Res> {
  _$HabitNoteCopyWithImpl(this._self, this._then);

  final HabitNote _self;
  final $Res Function(HabitNote) _then;

/// Create a copy of HabitNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? date = null,Object? text = null,}) {
  return _then(_self.copyWith(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitNote].
extension HabitNotePatterns on HabitNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitNote value)  $default,){
final _that = this;
switch (_that) {
case _HabitNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitNote value)?  $default,){
final _that = this;
switch (_that) {
case _HabitNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId,  DateTime date,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitNote() when $default != null:
return $default(_that.habitId,_that.date,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId,  DateTime date,  String text)  $default,) {final _that = this;
switch (_that) {
case _HabitNote():
return $default(_that.habitId,_that.date,_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId,  DateTime date,  String text)?  $default,) {final _that = this;
switch (_that) {
case _HabitNote() when $default != null:
return $default(_that.habitId,_that.date,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitNote implements HabitNote {
  const _HabitNote({required this.habitId, required this.date, required this.text});
  factory _HabitNote.fromJson(Map<String, dynamic> json) => _$HabitNoteFromJson(json);

@override final  String habitId;
@override final  DateTime date;
@override final  String text;

/// Create a copy of HabitNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitNoteCopyWith<_HabitNote> get copyWith => __$HabitNoteCopyWithImpl<_HabitNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitNote&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.date, date) || other.date == date)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,date,text);

@override
String toString() {
  return 'HabitNote(habitId: $habitId, date: $date, text: $text)';
}


}

/// @nodoc
abstract mixin class _$HabitNoteCopyWith<$Res> implements $HabitNoteCopyWith<$Res> {
  factory _$HabitNoteCopyWith(_HabitNote value, $Res Function(_HabitNote) _then) = __$HabitNoteCopyWithImpl;
@override @useResult
$Res call({
 String habitId, DateTime date, String text
});




}
/// @nodoc
class __$HabitNoteCopyWithImpl<$Res>
    implements _$HabitNoteCopyWith<$Res> {
  __$HabitNoteCopyWithImpl(this._self, this._then);

  final _HabitNote _self;
  final $Res Function(_HabitNote) _then;

/// Create a copy of HabitNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? date = null,Object? text = null,}) {
  return _then(_HabitNote(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
