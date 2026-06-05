// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitEntity {

 String get id; String get name; DateTime get createdDate;@_HabitScheduleConverter() HabitSchedule get schedule;@_HabitStateMapConverter() Map<int, HabitState> get daysStates; Map<int, int> get progress; HabitReminder? get reminder; HabitTarget? get target; String? get categoryId; List<String> get noteIds; int get sortIndex;
/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitEntityCopyWith<HabitEntity> get copyWith => _$HabitEntityCopyWithImpl<HabitEntity>(this as HabitEntity, _$identity);

  /// Serializes this HabitEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.daysStates, daysStates)&&const DeepCollectionEquality().equals(other.progress, progress)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.target, target) || other.target == target)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.noteIds, noteIds)&&(identical(other.sortIndex, sortIndex) || other.sortIndex == sortIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdDate,schedule,const DeepCollectionEquality().hash(daysStates),const DeepCollectionEquality().hash(progress),reminder,target,categoryId,const DeepCollectionEquality().hash(noteIds),sortIndex);

@override
String toString() {
  return 'HabitEntity(id: $id, name: $name, createdDate: $createdDate, schedule: $schedule, daysStates: $daysStates, progress: $progress, reminder: $reminder, target: $target, categoryId: $categoryId, noteIds: $noteIds, sortIndex: $sortIndex)';
}


}

/// @nodoc
abstract mixin class $HabitEntityCopyWith<$Res>  {
  factory $HabitEntityCopyWith(HabitEntity value, $Res Function(HabitEntity) _then) = _$HabitEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdDate,@_HabitScheduleConverter() HabitSchedule schedule,@_HabitStateMapConverter() Map<int, HabitState> daysStates, Map<int, int> progress, HabitReminder? reminder, HabitTarget? target, String? categoryId, List<String> noteIds, int sortIndex
});


$HabitScheduleCopyWith<$Res> get schedule;$HabitReminderCopyWith<$Res>? get reminder;$HabitTargetCopyWith<$Res>? get target;

}
/// @nodoc
class _$HabitEntityCopyWithImpl<$Res>
    implements $HabitEntityCopyWith<$Res> {
  _$HabitEntityCopyWithImpl(this._self, this._then);

  final HabitEntity _self;
  final $Res Function(HabitEntity) _then;

/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdDate = null,Object? schedule = null,Object? daysStates = null,Object? progress = null,Object? reminder = freezed,Object? target = freezed,Object? categoryId = freezed,Object? noteIds = null,Object? sortIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as HabitSchedule,daysStates: null == daysStates ? _self.daysStates : daysStates // ignore: cast_nullable_to_non_nullable
as Map<int, HabitState>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Map<int, int>,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as HabitReminder?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as HabitTarget?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,noteIds: null == noteIds ? _self.noteIds : noteIds // ignore: cast_nullable_to_non_nullable
as List<String>,sortIndex: null == sortIndex ? _self.sortIndex : sortIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitScheduleCopyWith<$Res> get schedule {
  
  return $HabitScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitReminderCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $HabitReminderCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $HabitTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitEntity].
extension HabitEntityPatterns on HabitEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitEntity value)  $default,){
final _that = this;
switch (_that) {
case _HabitEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HabitEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdDate, @_HabitScheduleConverter()  HabitSchedule schedule, @_HabitStateMapConverter()  Map<int, HabitState> daysStates,  Map<int, int> progress,  HabitReminder? reminder,  HabitTarget? target,  String? categoryId,  List<String> noteIds,  int sortIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitEntity() when $default != null:
return $default(_that.id,_that.name,_that.createdDate,_that.schedule,_that.daysStates,_that.progress,_that.reminder,_that.target,_that.categoryId,_that.noteIds,_that.sortIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdDate, @_HabitScheduleConverter()  HabitSchedule schedule, @_HabitStateMapConverter()  Map<int, HabitState> daysStates,  Map<int, int> progress,  HabitReminder? reminder,  HabitTarget? target,  String? categoryId,  List<String> noteIds,  int sortIndex)  $default,) {final _that = this;
switch (_that) {
case _HabitEntity():
return $default(_that.id,_that.name,_that.createdDate,_that.schedule,_that.daysStates,_that.progress,_that.reminder,_that.target,_that.categoryId,_that.noteIds,_that.sortIndex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime createdDate, @_HabitScheduleConverter()  HabitSchedule schedule, @_HabitStateMapConverter()  Map<int, HabitState> daysStates,  Map<int, int> progress,  HabitReminder? reminder,  HabitTarget? target,  String? categoryId,  List<String> noteIds,  int sortIndex)?  $default,) {final _that = this;
switch (_that) {
case _HabitEntity() when $default != null:
return $default(_that.id,_that.name,_that.createdDate,_that.schedule,_that.daysStates,_that.progress,_that.reminder,_that.target,_that.categoryId,_that.noteIds,_that.sortIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitEntity implements HabitEntity {
  const _HabitEntity({required this.id, required this.name, required this.createdDate, @_HabitScheduleConverter() required this.schedule, @_HabitStateMapConverter() final  Map<int, HabitState> daysStates = const <int, HabitState>{}, final  Map<int, int> progress = const <int, int>{}, this.reminder, this.target, this.categoryId, final  List<String> noteIds = const <String>[], this.sortIndex = 0}): _daysStates = daysStates,_progress = progress,_noteIds = noteIds;
  factory _HabitEntity.fromJson(Map<String, dynamic> json) => _$HabitEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime createdDate;
@override@_HabitScheduleConverter() final  HabitSchedule schedule;
 final  Map<int, HabitState> _daysStates;
@override@JsonKey()@_HabitStateMapConverter() Map<int, HabitState> get daysStates {
  if (_daysStates is EqualUnmodifiableMapView) return _daysStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_daysStates);
}

 final  Map<int, int> _progress;
@override@JsonKey() Map<int, int> get progress {
  if (_progress is EqualUnmodifiableMapView) return _progress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_progress);
}

@override final  HabitReminder? reminder;
@override final  HabitTarget? target;
@override final  String? categoryId;
 final  List<String> _noteIds;
@override@JsonKey() List<String> get noteIds {
  if (_noteIds is EqualUnmodifiableListView) return _noteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteIds);
}

@override@JsonKey() final  int sortIndex;

/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitEntityCopyWith<_HabitEntity> get copyWith => __$HabitEntityCopyWithImpl<_HabitEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other._daysStates, _daysStates)&&const DeepCollectionEquality().equals(other._progress, _progress)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.target, target) || other.target == target)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._noteIds, _noteIds)&&(identical(other.sortIndex, sortIndex) || other.sortIndex == sortIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdDate,schedule,const DeepCollectionEquality().hash(_daysStates),const DeepCollectionEquality().hash(_progress),reminder,target,categoryId,const DeepCollectionEquality().hash(_noteIds),sortIndex);

@override
String toString() {
  return 'HabitEntity(id: $id, name: $name, createdDate: $createdDate, schedule: $schedule, daysStates: $daysStates, progress: $progress, reminder: $reminder, target: $target, categoryId: $categoryId, noteIds: $noteIds, sortIndex: $sortIndex)';
}


}

/// @nodoc
abstract mixin class _$HabitEntityCopyWith<$Res> implements $HabitEntityCopyWith<$Res> {
  factory _$HabitEntityCopyWith(_HabitEntity value, $Res Function(_HabitEntity) _then) = __$HabitEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdDate,@_HabitScheduleConverter() HabitSchedule schedule,@_HabitStateMapConverter() Map<int, HabitState> daysStates, Map<int, int> progress, HabitReminder? reminder, HabitTarget? target, String? categoryId, List<String> noteIds, int sortIndex
});


@override $HabitScheduleCopyWith<$Res> get schedule;@override $HabitReminderCopyWith<$Res>? get reminder;@override $HabitTargetCopyWith<$Res>? get target;

}
/// @nodoc
class __$HabitEntityCopyWithImpl<$Res>
    implements _$HabitEntityCopyWith<$Res> {
  __$HabitEntityCopyWithImpl(this._self, this._then);

  final _HabitEntity _self;
  final $Res Function(_HabitEntity) _then;

/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdDate = null,Object? schedule = null,Object? daysStates = null,Object? progress = null,Object? reminder = freezed,Object? target = freezed,Object? categoryId = freezed,Object? noteIds = null,Object? sortIndex = null,}) {
  return _then(_HabitEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as HabitSchedule,daysStates: null == daysStates ? _self._daysStates : daysStates // ignore: cast_nullable_to_non_nullable
as Map<int, HabitState>,progress: null == progress ? _self._progress : progress // ignore: cast_nullable_to_non_nullable
as Map<int, int>,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as HabitReminder?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as HabitTarget?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,noteIds: null == noteIds ? _self._noteIds : noteIds // ignore: cast_nullable_to_non_nullable
as List<String>,sortIndex: null == sortIndex ? _self.sortIndex : sortIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitScheduleCopyWith<$Res> get schedule {
  
  return $HabitScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitReminderCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $HabitReminderCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}/// Create a copy of HabitEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $HabitTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}

// dart format on
