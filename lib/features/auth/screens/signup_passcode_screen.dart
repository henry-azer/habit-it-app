import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import 'passcode_setup_screen.dart';

/// AUTH-008 step 2 — PIN setup inside the signup chain.
///
/// On completion routes forward to the biometric opt-in (step 3).
class SignupPasscodeScreen extends StatelessWidget {
  const SignupPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PasscodeSetupScreen(
      title: 'Set your PIN',
      subtitle: 'Pick a 4-digit PIN you will remember.',
      onComplete: () => context.go(AppRoutes.signupBiometricPath),
    );
  }
}
