import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import 'biometric_opt_in_screen.dart';

/// AUTH-008 step 3 — biometric opt-in inside the signup chain.
class SignupBiometricOptInScreen extends StatelessWidget {
  const SignupBiometricOptInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void next() => context.go(AppRoutes.signupProfilePath);
    return BiometricOptInScreen(
      onEnabled: next,
      onSkip: next,
    );
  }
}
