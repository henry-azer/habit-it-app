import 'package:habit_it/core/data/repositories/auth_repository.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/managers/auth-token/auth_token_manager.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:habit_it/data/entities/user.dart';
import 'package:flutter/material.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthTokenManager _tokenManager;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl({
    required AuthTokenManager tokenManager,
    required UserLocalDataSource userLocalDataSource,
  })  : _tokenManager = tokenManager,
        _userLocalDataSource = userLocalDataSource;

  @override
  Future<void> saveSession(dynamic session) async {
    if (session is AuthSession) {
      await _tokenManager.saveSession(session);
    } else {
      throw ArgumentError('Invalid session type');
    }
  }

  @override
  Future<AuthSession?> getSession() async {
    return await _tokenManager.getSession();
  }

  @override
  Future<void> clearSession() async {
    await _tokenManager.clearSession();
  }

  @override
  Future<bool> isSessionExpired() async {
    return await _tokenManager.isSessionExpired();
  }

  @override
  Future<void> syncUserToLocal(AuthUser authUser) async {
    try {
      final metadata = authUser.metadata ?? {};
      final displayName = metadata['display_name'] as String?;
      final gender = metadata['gender'] as String?;
      final phoneNumber = metadata['phone_number'] as String?;
      final birthdayStr = metadata['birthday'] as String?;
      final birthday = birthdayStr != null ? DateTime.tryParse(birthdayStr) : null;

      final localUser = User(
        id: authUser.id,
        email: authUser.email,
        username: authUser.username ?? 'User',
        displayName: displayName,
        gender: gender,
        birthday: birthday,
        phoneNumber: phoneNumber,
        isAuthenticated: true,
        isOnboardingCompleted: true,
        emailVerified: authUser.emailVerified,
        lastSignInAt: authUser.lastSignInAt,
        createdDate: authUser.createdAt,
        metadata: authUser.metadata,
      );

      await _userLocalDataSource.setUser(localUser);
    } catch (e) {
      debugPrint('Error syncing user to local: $e');
      rethrow;
    }
  }

  @override
  Future<User?> getLocalUser() async {
    return await _userLocalDataSource.getUser();
  }

  @override
  Future<void> setAuthenticated(bool isAuthenticated) async {
    await _userLocalDataSource.setAuthenticated(isAuthenticated);
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _userLocalDataSource.isAuthenticated();
  }

  @override
  Future<void> setOnboardingCompleted(bool isCompleted) async {
    await _userLocalDataSource.setOnboardingCompleted(isCompleted);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await _userLocalDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> clearAllUserData() async {
    await _userLocalDataSource.clearUserData();
    await _tokenManager.clearAll();
  }
}
