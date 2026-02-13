import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';

abstract class IAuthService {
  Future<AuthResult<AuthSession>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthResult<AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    String? fullname,
    String? gender,
    DateTime? birthday,
    String? phoneNumber,
  });

  Future<AuthResult<void>> signOut();

  Future<AuthResult<void>> resetPassword(String email);

  Future<AuthResult<AuthSession>> refreshSession(String refreshToken);

  Future<AuthResult<AuthUser>> getCurrentUser();

  Future<AuthResult<void>> updateEmail(String newEmail);

  Future<AuthResult<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<AuthResult<void>> updateUsername(String username);

  Future<AuthResult<void>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
  });

  Future<AuthResult<void>> resendVerificationEmail();

  Stream<AuthUser?> get authStateChanges;

  Future<bool> isSessionValid();
}
