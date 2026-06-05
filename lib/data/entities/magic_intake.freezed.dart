// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'magic_intake.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MagicIntake {

 String get feelingText; Map<String, String> get answers;
/// Create a copy of MagicIntake
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MagicIntakeCopyWith<MagicIntake> get copyWith => _$MagicIntakeCopyWithImpl<MagicIntake>(this as MagicIntake, _$identity);

  /// Serializes this MagicIntake to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MagicIntake&&(identical(other.feelingText, feelingText) || other.feelingText == feelingText)&&const DeepCollectionEquality().equals(other.answers, answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feelingText,const DeepCollectionEquality().hash(answers));

@override
String toString() {
  return 'MagicIntake(feelingText: $feelingText, answers: $answers)';
}


}

/// @nodoc
abstract mixin class $MagicIntakeCopyWith<$Res>  {
  factory $MagicIntakeCopyWith(MagicIntake value, $Res Function(MagicIntake) _then) = _$MagicIntakeCopyWithImpl;
@useResult
$Res call({
 String feelingText, Map<String, String> answers
});




}
/// @nodoc
class _$MagicIntakeCopyWithImpl<$Res>
    implements $MagicIntakeCopyWith<$Res> {
  _$MagicIntakeCopyWithImpl(this._self, this._then);

  final MagicIntake _self;
  final $Res Function(MagicIntake) _then;

/// Create a copy of MagicIntake
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feelingText = null,Object? answers = null,}) {
  return _then(_self.copyWith(
feelingText: null == feelingText ? _self.feelingText : feelingText // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MagicIntake].
extension MagicIntakePatterns on MagicIntake {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MagicIntake value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MagicIntake() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MagicIntake value)  $default,){
final _that = this;
switch (_that) {
case _MagicIntake():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MagicIntake value)?  $default,){
final _that = this;
switch (_that) {
case _MagicIntake() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String feelingText,  Map<String, String> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MagicIntake() when $default != null:
return $default(_that.feelingText,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String feelingText,  Map<String, String> answers)  $default,) {final _that = this;
switch (_that) {
case _MagicIntake():
return $default(_that.feelingText,_that.answers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String feelingText,  Map<String, String> answers)?  $default,) {final _that = this;
switch (_that) {
case _MagicIntake() when $default != null:
return $default(_that.feelingText,_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MagicIntake implements MagicIntake {
  const _MagicIntake({required this.feelingText, final  Map<String, String> answers = const <String, String>{}}): _answers = answers;
  factory _MagicIntake.fromJson(Map<String, dynamic> json) => _$MagicIntakeFromJson(json);

@override final  String feelingText;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}


/// Create a copy of MagicIntake
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MagicIntakeCopyWith<_MagicIntake> get copyWith => __$MagicIntakeCopyWithImpl<_MagicIntake>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MagicIntakeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MagicIntake&&(identical(other.feelingText, feelingText) || other.feelingText == feelingText)&&const DeepCollectionEquality().equals(other._answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feelingText,const DeepCollectionEquality().hash(_answers));

@override
String toString() {
  return 'MagicIntake(feelingText: $feelingText, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$MagicIntakeCopyWith<$Res> implements $MagicIntakeCopyWith<$Res> {
  factory _$MagicIntakeCopyWith(_MagicIntake value, $Res Function(_MagicIntake) _then) = __$MagicIntakeCopyWithImpl;
@override @useResult
$Res call({
 String feelingText, Map<String, String> answers
});




}
/// @nodoc
class __$MagicIntakeCopyWithImpl<$Res>
    implements _$MagicIntakeCopyWith<$Res> {
  __$MagicIntakeCopyWithImpl(this._self, this._then);

  final _MagicIntake _self;
  final $Res Function(_MagicIntake) _then;

/// Create a copy of MagicIntake
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feelingText = null,Object? answers = null,}) {
  return _then(_MagicIntake(
feelingText: null == feelingText ? _self.feelingText : feelingText // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
