import 'package:get_it/get_it.dart';
import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/core/providers/base_auth_provider.dart';
import 'package:habit_it/core/data/repositories/auth_repository.dart';
import 'package:habit_it/core/data/entities/auth_result.dart';
import 'package:habit_it/core/services/i_auth_service.dart';
import 'package:habit_it/core/services/biometric_auth_manager.dart';

class SupabaseAuthProvider extends BaseAuthProvider {
  SupabaseAuthProvider({
    IAuthService? authService,
    IAuthRepository? authRepository,
    BiometricAuthManager? biometricManager,
  }) : super(
          authService: authService ?? GetIt.instance<IAuthService>(),
          authRepository: authRepository ?? GetIt.instance<IAuthRepository>(),
          biometricManager:
              biometricManager ?? GetIt.instance<BiometricAuthManager>(),
        );

  @override
  AuthUser extractUserFromSession(dynamic session) {
    if (session is AuthSession) {
      return session.user;
    }
    throw ArgumentError('Invalid session type for Supabase');
  }

  @override
  String extractRefreshToken(dynamic session) {
    if (session is AuthSession) {
      return session.refreshToken;
    }
    throw ArgumentError('Invalid session type for Supabase');
  }
}
