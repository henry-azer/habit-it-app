import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/core/data/entities/auth_failure.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:habit_it/core/data/repositories/auth_repository.dart';
import 'package:habit_it/core/services/i_auth_service.dart';
import 'package:habit_it/core/services/biometric_auth_manager.dart';
import 'package:habit_it/data/entities/user.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuthProvider with ChangeNotifier implements IAuthProvider {
  final IAuthService authService;
  final IAuthRepository authRepository;
  final BiometricAuthManager biometricManager;

  AuthState _authState = AuthState.initial;
  AuthUser? _currentAuthUser;
  User? _currentUser;
  String? _errorMessage;
  bool _obscurePassword = true;
  String? _lastSignInEmail;
  String? _lastSignInPassword;

  BaseAuthProvider({
    required this.authService,
    required this.authRepository,
    required this.biometricManager,
  }) {
    initialize();
  }

  @override
  AuthState get authState => _authState;

  @override
  AuthUser? get currentAuthUser => _currentAuthUser;

  @override
  User? get currentUser => _currentUser;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get isAuthenticated => _authState == AuthState.authenticated;

  @override
  bool get isLoading => _authState == AuthState.loading;

  @override
  bool get obscurePassword => _obscurePassword;

  @protected
  Future<void> initialize() async {
    setAuthState(AuthState.loading);

    try {
      await initializeSession();
      await listenToAuthStateChanges();
    } catch (e) {
      debugPrint('Initialization error: $e');
      setAuthState(AuthState.unauthenticated);
    }
  }

  @protected
  Future<void> initializeSession() async {
    final session = await authRepository.getSession();
    if (session != null) {
      final isExpired = await authRepository.isSessionExpired();

      if (!isExpired) {
        await handleValidSession(session);
      } else {
        await handleExpiredSession(session);
      }
    } else {
      setAuthState(AuthState.unauthenticated);
    }
  }

  @protected
  Future<void> handleValidSession(dynamic session) async {
    _currentAuthUser = extractUserFromSession(session);
    await authRepository.syncUserToLocal(_currentAuthUser!);
    _currentUser = await authRepository.getLocalUser();
    setAuthState(AuthState.authenticated);
  }

  @protected
  Future<void> handleExpiredSession(dynamic session) async {
    final refreshToken = extractRefreshToken(session);
    final refreshResult = await authService.refreshSession(refreshToken);

    await refreshResult.fold(
      onSuccess: (newSession) async {
        if (newSession != null) {
          await authRepository.saveSession(newSession);
          _currentAuthUser = newSession.user;
          await authRepository.syncUserToLocal(newSession.user);
          _currentUser = await authRepository.getLocalUser();
          setAuthState(AuthState.authenticated);
        }
      },
      onFailure: (failure) async {
        await authRepository.clearSession();
        setAuthState(AuthState.unauthenticated);
      },
    );
  }

  @protected
  Future<void> listenToAuthStateChanges() async {
    authService.authStateChanges.listen((authUser) async {
      if (authUser != null) {
        _currentAuthUser = authUser;
        await authRepository.syncUserToLocal(authUser);
        _currentUser = await authRepository.getLocalUser();
        if (_authState != AuthState.authenticated) {
          setAuthState(AuthState.authenticated);
        }
      } else {
        _currentAuthUser = null;
        _currentUser = null;
        if (_authState != AuthState.unauthenticated) {
          setAuthState(AuthState.unauthenticated);
        }
      }
      notifyListeners();
    });
  }

  @protected
  AuthUser extractUserFromSession(dynamic session);

  @protected
  String extractRefreshToken(dynamic session);

  @override
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    setAuthState(AuthState.loading);
    clearError();

    final result = await authService.signInWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      onSuccess: (session) async {
        if (session != null) {
          debugPrint('[AUTH] Sign-in successful → user_id: ${session.user.id}, email: ${session.user.email}');
          _lastSignInEmail = email;
          _lastSignInPassword = password;
          await handleSuccessfulSignIn(session);
          
          final isBiometricEnabled = await biometricManager.isBiometricEnabled();
          if (isBiometricEnabled) {
            final storedCredentials = await biometricManager.getBiometricCredentials();
            if (storedCredentials != null && storedCredentials['email'] != email) {
              debugPrint('[AUTH] Disabling biometric after login with another email');
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(AppLocalStorageKeys.biometricEnabled, false);
              await biometricManager.disableBiometric();
            } else {
              try {
                await biometricManager.updateBiometricCredentials(
                  email: email,
                  password: password,
                );
                debugPrint('[AUTH] Updated biometric credentials after sign-in');
              } catch (e) {
                debugPrint('[AUTH] Failed to update biometric credentials: $e');
              }
            }
          }
          
          return true;
        }
        return false;
      },
      onFailure: (failure) {
        debugPrint('[AUTH] Sign-in failed → error: ${failure.message}');
        handleAuthFailure(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? fullname,
    String? gender,
    DateTime? birthday,
    String? phoneNumber,
  }) async {
    setAuthState(AuthState.loading);
    clearError();

    final result = await authService.signUpWithEmail(
      email: email,
      password: password,
      fullname: fullname,
      gender: gender,
      birthday: birthday,
      phoneNumber: phoneNumber,
    );

    return result.fold(
      onSuccess: (session) async {
        await handleSuccessfulSignUp(session);
        return true;
      },
      onFailure: (failure) {
        handleAuthFailure(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> signInWithBiometric({required String reason}) async {
    setAuthState(AuthState.loading);
    clearError();

    final credentials = await biometricManager.getBiometricCredentials();
    if (credentials == null) {
      handleAuthFailure('No stored credentials found');
      return false;
    }

    final result = await biometricManager.authenticateWithBiometric(
      reason: reason,
    );

    return result.fold(
      onSuccess: (session) async {
        if (session != null) {
          debugPrint('[AUTH] Sign-in successful → user_id: ${session.user.id}, email: ${session.user.email}');
          _lastSignInEmail = credentials['email'];
          _lastSignInPassword = credentials['password'];
          _currentAuthUser = session.user;
          await authRepository.syncUserToLocal(session.user);
          _currentUser = await authRepository.getLocalUser();
          await authRepository.setAuthenticated(true);
          setAuthState(AuthState.authenticated);
          return true;
        }
        return false;
      },
      onFailure: (failure) {
        debugPrint('[AUTH] Biometric sign-in failed → error: ${failure.message}');
        handleAuthFailureWithCode(failure);
        return false;
      },
    );
  }

  @override
  Future<void> signOut() async {
    setAuthState(AuthState.loading);

    await authService.signOut();
    await authRepository.clearSession();
    await authRepository.setAuthenticated(false);

    _currentAuthUser = null;
    _currentUser = null;
    _lastSignInEmail = null;
    _lastSignInPassword = null;
    setAuthState(AuthState.unauthenticated);
  }

  @override
  Future<bool> resetPassword(String email) async {
    clearError();

    final result = await authService.resetPassword(email);

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> updateEmail(String newEmail) async {
    clearError();

    final result = await authService.updateEmail(newEmail);

    return result.fold(
      onSuccess: (_) async {
        if (_currentAuthUser != null) {
          _currentAuthUser = _currentAuthUser!.copyWith(email: newEmail);
          await authRepository.syncUserToLocal(_currentAuthUser!);
          _currentUser = await authRepository.getLocalUser();
          notifyListeners();
        }
        return true;
      },
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    clearError();
    debugPrint('[AUTH] Password change request → user_id: ${_currentAuthUser?.id}');

    final result = await authService.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      onSuccess: (_) async {
        debugPrint('[AUTH] Password change response → user_id: ${_currentAuthUser?.id}, success: true');
        
        final isBiometricEnabled = await biometricManager.isBiometricEnabled();
        if (isBiometricEnabled && _currentAuthUser?.email != null) {
          debugPrint('[AUTH] Updating biometric credentials with new password');
          try {
            await biometricManager.updateBiometricCredentials(
              email: _currentAuthUser!.email,
              password: newPassword,
            );
            debugPrint('[AUTH] Biometric credentials updated successfully');
          } catch (e) {
            debugPrint('[AUTH] Failed to update biometric credentials: $e');
          }
        }
        
        return true;
      },
      onFailure: (failure) {
        debugPrint('[AUTH] Password change response → user_id: ${_currentAuthUser?.id}, success: false, error: ${failure.message}');
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> updateUsername(String username) async {
    clearError();

    final result = await authService.updateUsername(username);

    return result.fold(
      onSuccess: (_) async {
        if (_currentAuthUser != null) {
          _currentAuthUser = _currentAuthUser!.copyWith(username: username);
          await authRepository.syncUserToLocal(_currentAuthUser!);
          _currentUser = await authRepository.getLocalUser();
          notifyListeners();
        }
        return true;
      },
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
  }) async {
    clearError();
    
    debugPrint('[AUTH] Update profile request → user_id: ${_currentAuthUser?.id}');
    if (displayName != null) debugPrint('[AUTH] → display_name: $displayName');
    if (phoneNumber != null) debugPrint('[AUTH] → phone_number: $phoneNumber');
    if (gender != null) debugPrint('[AUTH] → gender: $gender');
    if (birthday != null) debugPrint('[AUTH] → birthday: ${birthday.toIso8601String()}');

    final result = await authService.updateProfile(
      displayName: displayName,
      phoneNumber: phoneNumber,
      gender: gender,
      birthday: birthday,
    );

    return result.fold(
      onSuccess: (_) async {
        if (_currentAuthUser != null) {
          final updatedMetadata = Map<String, dynamic>.from(_currentAuthUser!.metadata ?? {});
          if (displayName != null) updatedMetadata['display_name'] = displayName;
          if (phoneNumber != null) updatedMetadata['phone_number'] = phoneNumber;
          if (gender != null) updatedMetadata['gender'] = gender;
          if (birthday != null) updatedMetadata['birthday'] = birthday.toIso8601String();
          
          _currentAuthUser = _currentAuthUser!.copyWith(
            metadata: updatedMetadata,
          );
          await authRepository.syncUserToLocal(_currentAuthUser!);
          _currentUser = await authRepository.getLocalUser();
          notifyListeners();
        }
        debugPrint('[AUTH] Profile update successful → user_id: ${_currentAuthUser?.id}');
        return true;
      },
      onFailure: (failure) {
        debugPrint('[AUTH] Profile update failed → error: ${failure.message}');
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> resendVerificationEmail() async {
    clearError();

    final result = await authService.resendVerificationEmail();

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> enableBiometric({
    required String reason,
    String? email,
    String? password,
  }) async {
    if (_currentAuthUser == null) {
      setError('No authenticated user');
      return false;
    }

    final session = await authRepository.getSession();
    if (session == null) {
      setError('No active session');
      return false;
    }

    final credentialEmail = email ?? _lastSignInEmail;
    final credentialPassword = password ?? _lastSignInPassword;

    if (credentialEmail == null || credentialPassword == null) {
      setError('Please sign in again to enable biometric authentication');
      return false;
    }

    final result = await biometricManager.enableBiometric(
      reason: reason,
      session: session,
      email: credentialEmail,
      password: credentialPassword,
    );

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> disableBiometric() async {
    final result = await biometricManager.disableBiometric();
    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await biometricManager.isBiometricEnabled();
  }

  @override
  Future<void> refreshSession() async {
    final session = await authRepository.getSession();
    if (session == null) return;

    final refreshToken = extractRefreshToken(session);
    final result = await authService.refreshSession(refreshToken);

    await result.fold(
      onSuccess: (newSession) async {
        if (newSession != null) {
          await authRepository.saveSession(newSession);
          _currentAuthUser = newSession.user;
          await authRepository.syncUserToLocal(newSession.user);
          _currentUser = await authRepository.getLocalUser();
          notifyListeners();
        }
      },
      onFailure: (failure) {
        debugPrint('Session refresh failed: ${failure.message}');
      },
    );
  }

  @override
  Future<bool> hasUser() async {
    try {
      final user = await authRepository.getLocalUser();
      return user != null;
    } catch (e) {
      debugPrint('Error checking user: $e');
      return false;
    }
  }

  @override
  Future<bool> isUserOnboarded() async {
    try {
      return await authRepository.isOnboardingCompleted();
    } catch (e) {
      debugPrint('Error checking onboarding: $e');
      return false;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await authRepository.clearAllUserData();
      _currentAuthUser = null;
      _currentUser = null;
      setAuthState(AuthState.unauthenticated);
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }

  @protected
  Future<void> handleSuccessfulSignIn(dynamic session) async {
    await authRepository.saveSession(session);
    _currentAuthUser = extractUserFromSession(session);
    await authRepository.syncUserToLocal(_currentAuthUser!);
    _currentUser = await authRepository.getLocalUser();
    await authRepository.setAuthenticated(true);
    setAuthState(AuthState.authenticated);
  }

  @protected
  Future<void> handleSuccessfulSignUp(dynamic session) async {
    await authRepository.saveSession(session);
    _currentAuthUser = extractUserFromSession(session);
    await authRepository.syncUserToLocal(_currentAuthUser!);
    _currentUser = await authRepository.getLocalUser();
    await authRepository.setAuthenticated(true);
    await authRepository.setOnboardingCompleted(true);
    setAuthState(AuthState.authenticated);
  }

  @protected
  void setAuthState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  @protected
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void clearError() {
    _errorMessage = null;
  }

  @protected
  void handleAuthFailure(String message) {
    setError(message);
    setAuthState(AuthState.error);
  }

  @protected
  void handleAuthFailureWithCode(AuthFailure failure) {
    final localizedMessage = _getLocalizedErrorMessage(failure);
    setError(localizedMessage);
    setAuthState(AuthState.error);
  }

  String _getLocalizedErrorMessage(AuthFailure failure) {
    switch (failure.code) {
      case 'biometric_failed':
        return AppStrings.biometricAuthFailed.tr;
      case 'biometric_not_available':
        return AppStrings.biometricNotAvailable.tr;
      default:
        return failure.message;
    }
  }

  @override
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
}
