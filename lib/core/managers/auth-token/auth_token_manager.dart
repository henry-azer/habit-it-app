import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';

class AuthTokenManager {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _expiresAtKey = 'auth_expires_at';
  static const String _userDataKey = 'auth_user_data';
  static const String _biometricEnabledKey = 'auth_biometric_enabled';
  static const String _biometricEmailKey = 'auth_biometric_email';
  static const String _biometricPasswordKey = 'auth_biometric_password';
  static const int _offlineGracePeriodDays = 7;

  final FlutterSecureStorage _secureStorage;

  AuthTokenManager({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  Future<void> saveSession(AuthSession session) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _accessTokenKey, value: session.accessToken),
        _secureStorage.write(
            key: _refreshTokenKey, value: session.refreshToken),
        _secureStorage.write(
            key: _expiresAtKey, value: session.expiresAt.toIso8601String()),
        _secureStorage.write(
            key: _userDataKey, value: jsonEncode(session.user.toJson())),
      ]);
    } catch (e) {
      debugPrint('Error saving session: $e');
      rethrow;
    }
  }

  Future<AuthSession?> getSession() async {
    try {
      final results = await Future.wait([
        _secureStorage.read(key: _accessTokenKey),
        _secureStorage.read(key: _refreshTokenKey),
        _secureStorage.read(key: _expiresAtKey),
        _secureStorage.read(key: _userDataKey),
      ]);

      final accessToken = results[0];
      final refreshToken = results[1];
      final expiresAtStr = results[2];
      final userDataStr = results[3];

      if (accessToken == null ||
          refreshToken == null ||
          expiresAtStr == null ||
          userDataStr == null) {
        return null;
      }

      final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
      final expiresAt = DateTime.parse(expiresAtStr);

      return AuthSession(
        user: AuthUser.fromJson(userData),
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
    } catch (e) {
      debugPrint('Error getting session: $e');
      return null;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      debugPrint('Error getting access token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      debugPrint('Error getting refresh token: $e');
      return null;
    }
  }

  Future<bool> isSessionExpired() async {
    try {
      final expiresAtStr = await _secureStorage.read(key: _expiresAtKey);
      if (expiresAtStr == null) return true;

      final expiresAt = DateTime.parse(expiresAtStr);
      return DateTime.now().isAfter(expiresAt);
    } catch (e) {
      debugPrint('Error checking session expiry: $e');
      return true;
    }
  }

  Future<bool> isWithinGracePeriod() async {
    try {
      final expiresAtStr = await _secureStorage.read(key: _expiresAtKey);
      if (expiresAtStr == null) return false;

      final expiresAt = DateTime.parse(expiresAtStr);
      final gracePeriodEnd =
          expiresAt.add(Duration(days: _offlineGracePeriodDays));

      return DateTime.now().isBefore(gracePeriodEnd);
    } catch (e) {
      debugPrint('Error checking grace period: $e');
      return false;
    }
  }

  Future<void> clearSession() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _secureStorage.delete(key: _expiresAtKey),
        _secureStorage.delete(key: _userDataKey),
      ]);
    } catch (e) {
      debugPrint('Error clearing session: $e');
      rethrow;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(
          key: _biometricEnabledKey, value: enabled.toString());
    } catch (e) {
      debugPrint('Error setting biometric enabled: $e');
      rethrow;
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      debugPrint('Error getting biometric enabled: $e');
      return false;
    }
  }

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing all secure storage: $e');
      rethrow;
    }
  }

  Future<void> saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _biometricEmailKey, value: email),
        _secureStorage.write(key: _biometricPasswordKey, value: password),
      ]);
    } catch (e) {
      debugPrint('Error saving biometric credentials: $e');
      rethrow;
    }
  }

  Future<Map<String, String>?> getBiometricCredentials() async {
    try {
      final results = await Future.wait([
        _secureStorage.read(key: _biometricEmailKey),
        _secureStorage.read(key: _biometricPasswordKey),
      ]);

      final email = results[0];
      final password = results[1];

      if (email == null || password == null) {
        return null;
      }

      return {
        'email': email,
        'password': password,
      };
    } catch (e) {
      debugPrint('Error getting biometric credentials: $e');
      return null;
    }
  }

  Future<void> clearBiometricCredentials() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _biometricEmailKey),
        _secureStorage.delete(key: _biometricPasswordKey),
      ]);
    } catch (e) {
      debugPrint('Error clearing biometric credentials: $e');
      rethrow;
    }
  }
}
