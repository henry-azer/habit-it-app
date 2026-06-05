import 'dart:developer' as developer;

import 'package:local_auth/local_auth.dart';

import 'i_biometric_manager.dart';

/// `local_auth ^2.3.0` wrapper. No persistence; the caller owns the opt-in
/// flag on `UserEntity` / `SettingsModel`.
class BiometricManagerImpl implements IBiometricManager {
  BiometricManagerImpl(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (e, st) {
      developer.log('biometric isAvailable failed', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<bool> authenticate({
    required String reason,
    bool stickyAuth = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          biometricOnly: false,
        ),
      );
    } catch (e, st) {
      developer.log('biometric authenticate failed',
          error: e, stackTrace: st);
      return false;
    }
  }
}
