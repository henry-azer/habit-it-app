import 'package:flutter/material.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/data/entities/user.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

abstract class IAuthProvider extends ChangeNotifier {
  AuthState get authState;
  AuthUser? get currentAuthUser;
  User? get currentUser;
  String? get errorMessage;
  bool get isAuthenticated;
  bool get isLoading;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  });

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? fullname,
    String? gender,
    DateTime? birthday,
    String? phoneNumber,
  });

  Future<bool> signInWithBiometric({required String reason});

  Future<void> signOut();

  Future<bool> resetPassword(String email);
  Future<bool> updateEmail(String newEmail);
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<bool> updateUsername(String username);
  Future<bool> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
  });
  Future<bool> resendVerificationEmail();

  Future<bool> enableBiometric({
    required String reason,
    String? email,
    String? password,
  });
  Future<bool> disableBiometric();
  Future<bool> isBiometricEnabled();

  Future<void> refreshSession();

  Future<bool> hasUser();
  Future<bool> isUserOnboarded();
  Future<void> clearUserData();

  void clearError();
  
  bool get obscurePassword;
  void togglePasswordVisibility();
}
