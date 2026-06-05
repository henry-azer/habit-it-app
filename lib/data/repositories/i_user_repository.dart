import '../entities/user_entity.dart';
import '../../core/utils/result.dart';

abstract class IUserRepository {
  Stream<UserEntity> watch();
  Future<Result<UserEntity>> get();
  Future<Result<void>> update(UserEntity user);
  Future<Result<void>> setUsernameAndGender(String username, String gender);
  Future<Result<void>> setAuthentication(bool value);
  Future<Result<void>> setPINAuthentication(bool value);
  Future<Result<void>> setBiometricAuthentication(bool value);

  /// AUTH-001 — clear the legacy plain-text password field once it has been
  /// hashed into secure storage.
  Future<Result<void>> clearLegacyPassword();
}
