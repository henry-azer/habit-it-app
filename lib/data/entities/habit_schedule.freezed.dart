// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
HabitSchedule _$HabitScheduleFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'daily':
          return ScheduleDaily.fromJson(
            json
          );
                case 'weekly':
          return ScheduleWeekly.fromJson(
            json
          );
                case 'monthlyAny':
          return ScheduleMonthlyAny.fromJson(
            json
          );
                case 'monthlyOn':
          return ScheduleMonthlyOn.fromJson(
            json
          );
                case 'oneTime':
          return ScheduleOneTime.fromJson(
            json
          );
                case 'none':
          return ScheduleNone.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'HabitSchedule',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$HabitSchedule {



  /// Serializes this HabitSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitSchedule);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HabitSchedule()';
}


}

/// @nodoc
class $HabitScheduleCopyWith<$Res>  {
$HabitScheduleCopyWith(HabitSchedule _, $Res Function(HabitSchedule) __);
}


/// Adds pattern-matching-related methods to [HabitSchedule].
extension HabitSchedulePatterns on HabitSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScheduleDaily value)?  daily,TResult Function( ScheduleWeekly value)?  weekly,TResult Function( ScheduleMonthlyAny value)?  monthlyAny,TResult Function( ScheduleMonthlyOn value)?  monthlyOn,TResult Function( ScheduleOneTime value)?  oneTime,TResult Function( ScheduleNone value)?  none,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScheduleDaily() when daily != null:
return daily(_that);case ScheduleWeekly() when weekly != null:
return weekly(_that);case ScheduleMonthlyAny() when monthlyAny != null:
return monthlyAny(_that);case ScheduleMonthlyOn() when monthlyOn != null:
return monthlyOn(_that);case ScheduleOneTime() when oneTime != null:
return oneTime(_that);case ScheduleNone() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScheduleDaily value)  daily,required TResult Function( ScheduleWeekly value)  weekly,required TResult Function( ScheduleMonthlyAny value)  monthlyAny,required TResult Function( ScheduleMonthlyOn value)  monthlyOn,required TResult Function( ScheduleOneTime value)  oneTime,required TResult Function( ScheduleNone value)  none,}){
final _that = this;
switch (_that) {
case ScheduleDaily():
return daily(_that);case ScheduleWeekly():
return weekly(_that);case ScheduleMonthlyAny():
return monthlyAny(_that);case ScheduleMonthlyOn():
return monthlyOn(_that);case ScheduleOneTime():
return oneTime(_that);case ScheduleNone():
return none(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScheduleDaily value)?  daily,TResult? Function( ScheduleWeekly value)?  weekly,TResult? Function( ScheduleMonthlyAny value)?  monthlyAny,TResult? Function( ScheduleMonthlyOn value)?  monthlyOn,TResult? Function( ScheduleOneTime value)?  oneTime,TResult? Function( ScheduleNone value)?  none,}){
final _that = this;
switch (_that) {
case ScheduleDaily() when daily != null:
return daily(_that);case ScheduleWeekly() when weekly != null:
return weekly(_that);case ScheduleMonthlyAny() when monthlyAny != null:
return monthlyAny(_that);case ScheduleMonthlyOn() when monthlyOn != null:
return monthlyOn(_that);case ScheduleOneTime() when oneTime != null:
return oneTime(_that);case ScheduleNone() when none != null:
return none(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  daily,TResult Function( List<String> weekdays)?  weekly,TResult Function()?  monthlyAny,TResult Function( List<int> daysOfMonth)?  monthlyOn,TResult Function( DateTime date)?  oneTime,TResult Function()?  none,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScheduleDaily() when daily != null:
return daily();case ScheduleWeekly() when weekly != null:
return weekly(_that.weekdays);case ScheduleMonthlyAny() when monthlyAny != null:
return monthlyAny();case ScheduleMonthlyOn() when monthlyOn != null:
return monthlyOn(_that.daysOfMonth);case ScheduleOneTime() when oneTime != null:
return oneTime(_that.date);case ScheduleNone() when none != null:
return none();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  daily,required TResult Function( List<String> weekdays)  weekly,required TResult Function()  monthlyAny,required TResult Function( List<int> daysOfMonth)  monthlyOn,required TResult Function( DateTime date)  oneTime,required TResult Function()  none,}) {final _that = this;
switch (_that) {
case ScheduleDaily():
return daily();case ScheduleWeekly():
return weekly(_that.weekdays);case ScheduleMonthlyAny():
return monthlyAny();case ScheduleMonthlyOn():
return monthlyOn(_that.daysOfMonth);case ScheduleOneTime():
return oneTime(_that.date);case ScheduleNone():
return none();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  daily,TResult? Function( List<String> weekdays)?  weekly,TResult? Function()?  monthlyAny,TResult? Function( List<int> daysOfMonth)?  monthlyOn,TResult? Function( DateTime date)?  oneTime,TResult? Function()?  none,}) {final _that = this;
switch (_that) {
case ScheduleDaily() when daily != null:
return daily();case ScheduleWeekly() when weekly != null:
return weekly(_that.weekdays);case ScheduleMonthlyAny() when monthlyAny != null:
return monthlyAny();case ScheduleMonthlyOn() when monthlyOn != null:
return monthlyOn(_that.daysOfMonth);case ScheduleOneTime() when oneTime != null:
return oneTime(_that.date);case ScheduleNone() when none != null:
return none();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ScheduleDaily extends HabitSchedule {
  const ScheduleDaily({final  String? $type}): $type = $type ?? 'daily',super._();
  factory ScheduleDaily.fromJson(Map<String, dynamic> json) => _$ScheduleDailyFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$ScheduleDailyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDaily);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HabitSchedule.daily()';
}


}




/// @nodoc
@JsonSerializable()

class ScheduleWeekly extends HabitSchedule {
  const ScheduleWeekly({required final  List<String> weekdays, final  String? $type}): _weekdays = weekdays,$type = $type ?? 'weekly',super._();
  factory ScheduleWeekly.fromJson(Map<String, dynamic> json) => _$ScheduleWeeklyFromJson(json);

 final  List<String> _weekdays;
 List<String> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWeeklyCopyWith<ScheduleWeekly> get copyWith => _$ScheduleWeeklyCopyWithImpl<ScheduleWeekly>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleWeeklyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWeekly&&const DeepCollectionEquality().equals(other._weekdays, _weekdays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_weekdays));

@override
String toString() {
  return 'HabitSchedule.weekly(weekdays: $weekdays)';
}


}

/// @nodoc
abstract mixin class $ScheduleWeeklyCopyWith<$Res> implements $HabitScheduleCopyWith<$Res> {
  factory $ScheduleWeeklyCopyWith(ScheduleWeekly value, $Res Function(ScheduleWeekly) _then) = _$ScheduleWeeklyCopyWithImpl;
@useResult
$Res call({
 List<String> weekdays
});




}
/// @nodoc
class _$ScheduleWeeklyCopyWithImpl<$Res>
    implements $ScheduleWeeklyCopyWith<$Res> {
  _$ScheduleWeeklyCopyWithImpl(this._self, this._then);

  final ScheduleWeekly _self;
  final $Res Function(ScheduleWeekly) _then;

/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weekdays = null,}) {
  return _then(ScheduleWeekly(
weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ScheduleMonthlyAny extends HabitSchedule {
  const ScheduleMonthlyAny({final  String? $type}): $type = $type ?? 'monthlyAny',super._();
  factory ScheduleMonthlyAny.fromJson(Map<String, dynamic> json) => _$ScheduleMonthlyAnyFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$ScheduleMonthlyAnyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleMonthlyAny);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HabitSchedule.monthlyAny()';
}


}




/// @nodoc
@JsonSerializable()

class ScheduleMonthlyOn extends HabitSchedule {
  const ScheduleMonthlyOn({required final  List<int> daysOfMonth, final  String? $type}): _daysOfMonth = daysOfMonth,$type = $type ?? 'monthlyOn',super._();
  factory ScheduleMonthlyOn.fromJson(Map<String, dynamic> json) => _$ScheduleMonthlyOnFromJson(json);

 final  List<int> _daysOfMonth;
 List<int> get daysOfMonth {
  if (_daysOfMonth is EqualUnmodifiableListView) return _daysOfMonth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfMonth);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleMonthlyOnCopyWith<ScheduleMonthlyOn> get copyWith => _$ScheduleMonthlyOnCopyWithImpl<ScheduleMonthlyOn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleMonthlyOnToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleMonthlyOn&&const DeepCollectionEquality().equals(other._daysOfMonth, _daysOfMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_daysOfMonth));

@override
String toString() {
  return 'HabitSchedule.monthlyOn(daysOfMonth: $daysOfMonth)';
}


}

/// @nodoc
abstract mixin class $ScheduleMonthlyOnCopyWith<$Res> implements $HabitScheduleCopyWith<$Res> {
  factory $ScheduleMonthlyOnCopyWith(ScheduleMonthlyOn value, $Res Function(ScheduleMonthlyOn) _then) = _$ScheduleMonthlyOnCopyWithImpl;
@useResult
$Res call({
 List<int> daysOfMonth
});




}
/// @nodoc
class _$ScheduleMonthlyOnCopyWithImpl<$Res>
    implements $ScheduleMonthlyOnCopyWith<$Res> {
  _$ScheduleMonthlyOnCopyWithImpl(this._self, this._then);

  final ScheduleMonthlyOn _self;
  final $Res Function(ScheduleMonthlyOn) _then;

/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? daysOfMonth = null,}) {
  return _then(ScheduleMonthlyOn(
daysOfMonth: null == daysOfMonth ? _self._daysOfMonth : daysOfMonth // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ScheduleOneTime extends HabitSchedule {
  const ScheduleOneTime({required this.date, final  String? $type}): $type = $type ?? 'oneTime',super._();
  factory ScheduleOneTime.fromJson(Map<String, dynamic> json) => _$ScheduleOneTimeFromJson(json);

 final  DateTime date;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleOneTimeCopyWith<ScheduleOneTime> get copyWith => _$ScheduleOneTimeCopyWithImpl<ScheduleOneTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleOneTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleOneTime&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date);

@override
String toString() {
  return 'HabitSchedule.oneTime(date: $date)';
}


}

/// @nodoc
abstract mixin class $ScheduleOneTimeCopyWith<$Res> implements $HabitScheduleCopyWith<$Res> {
  factory $ScheduleOneTimeCopyWith(ScheduleOneTime value, $Res Function(ScheduleOneTime) _then) = _$ScheduleOneTimeCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$ScheduleOneTimeCopyWithImpl<$Res>
    implements $ScheduleOneTimeCopyWith<$Res> {
  _$ScheduleOneTimeCopyWithImpl(this._self, this._then);

  final ScheduleOneTime _self;
  final $Res Function(ScheduleOneTime) _then;

/// Create a copy of HabitSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(ScheduleOneTime(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ScheduleNone extends HabitSchedule {
  const ScheduleNone({final  String? $type}): $type = $type ?? 'none',super._();
  factory ScheduleNone.fromJson(Map<String, dynamic> json) => _$ScheduleNoneFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$ScheduleNoneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleNone);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HabitSchedule.none()';
}


}




// dart format on
