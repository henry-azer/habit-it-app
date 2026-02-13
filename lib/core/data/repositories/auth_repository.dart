import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/data/entities/user.dart';

abstract class IAuthRepository {
  Future<void> saveSession(dynamic session);

  Future<dynamic> getSession();

  Future<void> clearSession();

  Future<bool> isSessionExpired();

  Future<void> syncUserToLocal(AuthUser authUser);

  Future<User?> getLocalUser();

  Future<void> setAuthenticated(bool isAuthenticated);

  Future<bool> isAuthenticated();

  Future<void> setOnboardingCompleted(bool isCompleted);

  Future<bool> isOnboardingCompleted();

  Future<void> clearAllUserData();
}
