import 'package:flutter/foundation.dart';
import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/data/entities/auth_failure.dart';
import 'package:habit_it/core/managers/auth-token/auth_token_manager.dart';
import 'package:habit_it/core/services/i_auth_service.dart';
import 'package:habit_it/core/providers/biometric_provider.dart';

class BiometricAuthManager {
  final AuthTokenManager _tokenManager;
  final BiometricProvider _biometricProvider;
  final IAuthService _authService;

  BiometricAuthManager({
    required AuthTokenManager tokenManager,
    required BiometricProvider biometricProvider,
    required IAuthService authService,
  })  : _tokenManager = tokenManager,
        _biometricProvider = biometricProvider,
        _authService = authService;

  Future<AuthResult<AuthSession>> authenticateWithBiometric({
    required String reason,
  }) async {
    try {
      if (!_biometricProvider.isBiometricAvailable) {
        return AuthResult.failure(const BiometricNotAvailableFailure());
      }

      final isBiometricEnabled = await _tokenManager.isBiometricEnabled();
      if (!isBiometricEnabled) {
        return AuthResult.failure(
          const BiometricNotAvailableFailure('Biometric authentication is not enabled'),
        );
      }

      final authenticated = await _biometricProvider.authenticate(
        reason: reason,
      );

      if (!authenticated) {
        return AuthResult.failure(const BiometricFailedFailure());
      }

      final credentials = await _tokenManager.getBiometricCredentials();
      if (credentials == null) {
        return AuthResult.failure(
          const TokenExpiredFailure('No stored credentials found'),
        );
      }

      final signInResult = await _authService.signInWithEmail(
        email: credentials['email']!,
        password: credentials['password']!,
      );

      return signInResult.fold(
        onSuccess: (session) async {
          if (session != null) {
            await _tokenManager.saveSession(session);
            return AuthResult.success(session);
          }
          return AuthResult.failure(
            const UnknownFailure('Sign-in returned null session'),
          );
        },
        onFailure: (failure) {
          return AuthResult.failure(failure);
        },
      );
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return AuthResult.failure(UnknownFailure(e.toString()));
    }
  }

  Future<AuthResult<void>> enableBiometric({
    required String reason,
    required AuthSession session,
    required String email,
    required String password,
  }) async {
    try {
      if (!_biometricProvider.isBiometricAvailable) {
        return AuthResult.failure(const BiometricNotAvailableFailure());
      }

      final authenticated = await _biometricProvider.authenticate(
        reason: reason,
      );

      if (!authenticated) {
        return AuthResult.failure(const BiometricFailedFailure());
      }

      await _tokenManager.saveSession(session);
      await _tokenManager.saveBiometricCredentials(
        email: email,
        password: password,
      );
      await _tokenManager.setBiometricEnabled(true);
      await _biometricProvider.refresh();

      return AuthResult.success(null);
    } catch (e) {
      debugPrint('Enable biometric error: $e');
      return AuthResult.failure(UnknownFailure(e.toString()));
    }
  }

  Future<AuthResult<void>> disableBiometric() async {
    try {
      await _tokenManager.setBiometricEnabled(false);
      await _tokenManager.clearBiometricCredentials();
      await _biometricProvider.refresh();
      return AuthResult.success(null);
    } catch (e) {
      debugPrint('Disable biometric error: $e');
      return AuthResult.failure(UnknownFailure(e.toString()));
    }
  }

  Future<bool> isBiometricEnabled() async {
    return await _tokenManager.isBiometricEnabled();
  }

  Future<void> updateBiometricCredentials({
    required String email,
    required String password,
  }) async {
    await _tokenManager.saveBiometricCredentials(
      email: email,
      password: password,
    );
  }

  Future<Map<String, String>?> getBiometricCredentials() async {
    return await _tokenManager.getBiometricCredentials();
  }
}
