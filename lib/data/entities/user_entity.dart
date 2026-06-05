import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// User profile + auth flags held in the `user` Hive box under `user_state`.
///
/// `password` is *deprecated*: AUTH-001 stores PINs in flutter_secure_storage
/// as PBKDF2-SHA256 hashes. The field is retained so legacy installs can be
/// migrated by `AuthMigrator` before the field is cleared.
@freezed
sealed class UserEntity with _$UserEntity {
  const factory UserEntity({
    @Default('') String id,
    @Default('') String username,
    @Default('') String gender,
    String? password, // deprecated, cleared post-migration
    @Default(false) bool isRegistered,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isPINAuthenticated,
    @Default(false) bool isBiometricAuthenticated,
  }) = _UserEntity;

  factory UserEntity.defaults() => const UserEntity();

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
