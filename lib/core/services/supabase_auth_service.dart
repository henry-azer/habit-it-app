import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/data/entities/auth_user.dart' as domain;
import 'package:habit_it/core/data/entities/auth_failure.dart';
import 'package:habit_it/core/services/i_auth_service.dart';

class SupabaseAuthService implements IAuthService {
  final SupabaseClient _supabase;
  final StreamController<domain.AuthUser?> _authStateController =
      StreamController<domain.AuthUser?>.broadcast();

  SupabaseAuthService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _authStateController.add(_mapSupabaseUserToAuthUser(session.user));
      } else {
        _authStateController.add(null);
      }
    });
  }

  @override
  Stream<domain.AuthUser?> get authStateChanges => _authStateController.stream;

  @override
  Future<AuthResult<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[AUTH] Sign-in request → email: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null || response.user == null) {
        return AuthResult.failure(
            const InvalidCredentialsFailure('Failed to sign in'));
      }

      final session = _mapSupabaseSessionToAuthSession(
        response.session!,
        response.user!,
      );

      return AuthResult.success(session);
    } on AuthException catch (e) {
      final failure = _mapAuthException(e);
      return AuthResult.failure(failure);
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Sign in error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    String? fullname,
    String? gender,
    DateTime? birthday,
    String? phoneNumber,
  }) async {
    try {
      final metadata = {
        if (fullname != null) 'display_name': fullname,
        if (gender != null) 'gender': gender,
        if (birthday != null) 'birthday': birthday.toIso8601String(),
        if (phoneNumber != null) 'phone_number': phoneNumber,
      };
      
      debugPrint('[AUTH] Sign-up request → email: $email');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      debugPrint('[AUTH] Sign-up response → user_id: ${response.user?.id}, email: ${response.user?.email}, session: ${response.session != null}, email_confirmed: ${response.user?.emailConfirmedAt != null}');

      if (response.user == null) {
        return AuthResult.failure(
            const ServerFailure('Failed to create account: No user returned'));
      }

      if (response.session == null) {
        return AuthResult.failure(
            const ServerFailure('Email confirmation is enabled. Please disable it in Supabase Dashboard: Authentication → Providers → Email → Turn off "Confirm email"'));
      }

      final session = _mapSupabaseSessionToAuthSession(
        response.session!,
        response.user!,
      );

      return AuthResult.success(session);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Sign up error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Sign out error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> resetPassword(String email) async {
    try {
      debugPrint('[AUTH] Reset password request → email: $email');
      
      await _supabase.auth.resetPasswordForEmail(email);
      
      debugPrint('[AUTH] Reset password response → email sent successfully');
      
      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Reset password error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<AuthSession>> refreshSession(String refreshToken) async {
    try {
      final response = await _supabase.auth.refreshSession();

      if (response.session == null || response.user == null) {
        return AuthResult.failure(
            const TokenExpiredFailure('Failed to refresh session'));
      }

      final session = _mapSupabaseSessionToAuthSession(
        response.session!,
        response.user!,
      );

      return AuthResult.success(session);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Refresh session error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<domain.AuthUser>> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return AuthResult.failure(const UserNotFoundFailure());
      }

      return AuthResult.success(_mapSupabaseUserToAuthUser(user));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Get current user error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> updateEmail(String newEmail) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      if (response.user == null) {
        return AuthResult.failure(const ServerFailure('Failed to update email'));
      }

      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Update email error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        return AuthResult.failure(
            const ServerFailure('Failed to update password'));
      }

      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Update password error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> updateUsername(String username) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(data: {'username': username}),
      );

      if (response.user == null) {
        return AuthResult.failure(
            const ServerFailure('Failed to update username'));
      }

      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Update username error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
  }) async {
    try {
      final Map<String, dynamic> metadata = {};
      
      if (displayName != null) metadata['display_name'] = displayName;
      if (phoneNumber != null) metadata['phone_number'] = phoneNumber;
      if (gender != null) metadata['gender'] = gender;
      if (birthday != null) metadata['birthday'] = birthday.toIso8601String();

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: metadata),
      );

      if (response.user == null) {
        return AuthResult.failure(
            const ServerFailure('Failed to update profile'));
      }

      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Update profile error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult<void>> resendVerificationEmail() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || user.email == null) {
        return AuthResult.failure(const UserNotFoundFailure());
      }

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: user.email!,
      );

      return AuthResult.success(null);
    } on AuthException catch (e) {
      return AuthResult.failure(_mapAuthException(e));
    } catch (e) {
      final failure = _mapNetworkException(e);
      debugPrint('Resend verification email error: ${failure.message}');
      return AuthResult.failure(failure);
    }
  }

  @override
  Future<bool> isSessionValid() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) return false;

      final expiresAt =
          DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
      return DateTime.now().isBefore(expiresAt);
    } catch (e) {
      debugPrint('Session validation error: $e');
      return false;
    }
  }

  domain.AuthUser _mapSupabaseUserToAuthUser(User user) {
    return domain.AuthUser(
      id: user.id,
      email: user.email ?? '',
      username: user.userMetadata?['display_name'] as String?,
      emailVerified: user.emailConfirmedAt != null,
      lastSignInAt: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt!)
          : null,
      createdAt: DateTime.parse(user.createdAt),
      metadata: user.userMetadata,
    );
  }

  AuthSession _mapSupabaseSessionToAuthSession(Session session, User user) {
    return AuthSession(
      user: _mapSupabaseUserToAuthUser(user),
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000),
    );
  }

  AuthFailure _mapAuthException(AuthException exception) {
    final errorMessage = exception.message.toLowerCase();
    
    if (errorMessage.contains('failed host lookup') ||
        errorMessage.contains('no address associated with hostname')) {
      return const ServerFailure('Unable to reach server. Please try again later.');
    }
    
    if (errorMessage.contains('socketexception') ||
        errorMessage.contains('network is unreachable') ||
        errorMessage.contains('clientexception')) {
      return const NetworkFailure('Connection failed. Please check your internet connection and try again.');
    }
    
    if (errorMessage.contains('timeout') || errorMessage.contains('timed out')) {
      return const NetworkFailure('Connection timeout. Please check your internet connection and try again.');
    }
    
    if (errorMessage.contains('handshake') || errorMessage.contains('certificate')) {
      return const NetworkFailure('Connection security error. Please try again later.');
    }
    
    switch (exception.statusCode) {
      case '400':
        if (errorMessage.contains('email')) {
          return InvalidEmailFailure(exception.message);
        } else if (errorMessage.contains('password')) {
          return WeakPasswordFailure(exception.message);
        }
        return UnknownFailure(exception.message);
      case '401':
        return const InvalidCredentialsFailure('Invalid credentials');
      case '422':
        if (errorMessage.contains('already registered') || 
            errorMessage.contains('already exists')) {
          return const EmailAlreadyInUseFailure('Email is already exists');
        }
        return UnknownFailure(exception.message);
      case '500':
        return ServerFailure(exception.message);
      default:
        return UnknownFailure(exception.message);
    }
  }

  AuthFailure _mapNetworkException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    
    if (errorString.contains('socketexception') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('network is unreachable') ||
        errorString.contains('no address associated with hostname')) {
      return const NetworkFailure('No internet connection. Please check your network and try again.');
    }
    
    if (errorString.contains('timeout') ||
        errorString.contains('timed out')) {
      return const NetworkFailure('Connection timeout. Please check your internet connection and try again.');
    }
    
    if (errorString.contains('handshake') ||
        errorString.contains('certificate')) {
      return const NetworkFailure('Connection security error. Please try again later.');
    }
    
    return UnknownFailure(exception.toString());
  }

  void dispose() {
    _authStateController.close();
  }
}
