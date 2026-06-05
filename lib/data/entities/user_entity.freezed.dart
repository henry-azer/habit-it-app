// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserEntity {

 String get id; String get username; String get gender; String? get password;// deprecated, cleared post-migration
 bool get isRegistered; bool get isAuthenticated; bool get isPINAuthenticated; bool get isBiometricAuthenticated;
/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEntityCopyWith<UserEntity> get copyWith => _$UserEntityCopyWithImpl<UserEntity>(this as UserEntity, _$identity);

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.password, password) || other.password == password)&&(identical(other.isRegistered, isRegistered) || other.isRegistered == isRegistered)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.isPINAuthenticated, isPINAuthenticated) || other.isPINAuthenticated == isPINAuthenticated)&&(identical(other.isBiometricAuthenticated, isBiometricAuthenticated) || other.isBiometricAuthenticated == isBiometricAuthenticated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,gender,password,isRegistered,isAuthenticated,isPINAuthenticated,isBiometricAuthenticated);

@override
String toString() {
  return 'UserEntity(id: $id, username: $username, gender: $gender, password: $password, isRegistered: $isRegistered, isAuthenticated: $isAuthenticated, isPINAuthenticated: $isPINAuthenticated, isBiometricAuthenticated: $isBiometricAuthenticated)';
}


}

/// @nodoc
abstract mixin class $UserEntityCopyWith<$Res>  {
  factory $UserEntityCopyWith(UserEntity value, $Res Function(UserEntity) _then) = _$UserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String username, String gender, String? password, bool isRegistered, bool isAuthenticated, bool isPINAuthenticated, bool isBiometricAuthenticated
});




}
/// @nodoc
class _$UserEntityCopyWithImpl<$Res>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._self, this._then);

  final UserEntity _self;
  final $Res Function(UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? gender = null,Object? password = freezed,Object? isRegistered = null,Object? isAuthenticated = null,Object? isPINAuthenticated = null,Object? isBiometricAuthenticated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,isRegistered: null == isRegistered ? _self.isRegistered : isRegistered // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isPINAuthenticated: null == isPINAuthenticated ? _self.isPINAuthenticated : isPINAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isBiometricAuthenticated: null == isBiometricAuthenticated ? _self.isBiometricAuthenticated : isBiometricAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEntity].
extension UserEntityPatterns on UserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String gender,  String? password,  bool isRegistered,  bool isAuthenticated,  bool isPINAuthenticated,  bool isBiometricAuthenticated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.username,_that.gender,_that.password,_that.isRegistered,_that.isAuthenticated,_that.isPINAuthenticated,_that.isBiometricAuthenticated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String gender,  String? password,  bool isRegistered,  bool isAuthenticated,  bool isPINAuthenticated,  bool isBiometricAuthenticated)  $default,) {final _that = this;
switch (_that) {
case _UserEntity():
return $default(_that.id,_that.username,_that.gender,_that.password,_that.isRegistered,_that.isAuthenticated,_that.isPINAuthenticated,_that.isBiometricAuthenticated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String gender,  String? password,  bool isRegistered,  bool isAuthenticated,  bool isPINAuthenticated,  bool isBiometricAuthenticated)?  $default,) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.username,_that.gender,_that.password,_that.isRegistered,_that.isAuthenticated,_that.isPINAuthenticated,_that.isBiometricAuthenticated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserEntity implements UserEntity {
  const _UserEntity({this.id = '', this.username = '', this.gender = '', this.password, this.isRegistered = false, this.isAuthenticated = false, this.isPINAuthenticated = false, this.isBiometricAuthenticated = false});
  factory _UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String username;
@override@JsonKey() final  String gender;
@override final  String? password;
// deprecated, cleared post-migration
@override@JsonKey() final  bool isRegistered;
@override@JsonKey() final  bool isAuthenticated;
@override@JsonKey() final  bool isPINAuthenticated;
@override@JsonKey() final  bool isBiometricAuthenticated;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEntityCopyWith<_UserEntity> get copyWith => __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.password, password) || other.password == password)&&(identical(other.isRegistered, isRegistered) || other.isRegistered == isRegistered)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.isPINAuthenticated, isPINAuthenticated) || other.isPINAuthenticated == isPINAuthenticated)&&(identical(other.isBiometricAuthenticated, isBiometricAuthenticated) || other.isBiometricAuthenticated == isBiometricAuthenticated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,gender,password,isRegistered,isAuthenticated,isPINAuthenticated,isBiometricAuthenticated);

@override
String toString() {
  return 'UserEntity(id: $id, username: $username, gender: $gender, password: $password, isRegistered: $isRegistered, isAuthenticated: $isAuthenticated, isPINAuthenticated: $isPINAuthenticated, isBiometricAuthenticated: $isBiometricAuthenticated)';
}


}

/// @nodoc
abstract mixin class _$UserEntityCopyWith<$Res> implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(_UserEntity value, $Res Function(_UserEntity) _then) = __$UserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String gender, String? password, bool isRegistered, bool isAuthenticated, bool isPINAuthenticated, bool isBiometricAuthenticated
});




}
/// @nodoc
class __$UserEntityCopyWithImpl<$Res>
    implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(this._self, this._then);

  final _UserEntity _self;
  final $Res Function(_UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? gender = null,Object? password = freezed,Object? isRegistered = null,Object? isAuthenticated = null,Object? isPINAuthenticated = null,Object? isBiometricAuthenticated = null,}) {
  return _then(_UserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,isRegistered: null == isRegistered ? _self.isRegistered : isRegistered // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isPINAuthenticated: null == isPINAuthenticated ? _self.isPINAuthenticated : isPINAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isBiometricAuthenticated: null == isBiometricAuthenticated ? _self.isBiometricAuthenticated : isBiometricAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
