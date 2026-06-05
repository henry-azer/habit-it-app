import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// AUTH-008 step 1 — Welcome.
///
/// Lightweight intro that bridges onboarding/splash → PasscodeSetup. Does
/// not persist anything.
class SignupWelcomeScreen extends StatelessWidget {
  const SignupWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.task_alt_rounded,
                size: 92,
                color: AppColors.accentDefault,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Welcome to Habit-It',
                style: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Let's set up your account in three quick steps:\n"
                'create a PIN, optionally enable biometric unlock, and pick a name.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.go(AppRoutes.signupPasscodePath);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentDefault,
                    foregroundColor: AppColors.darkOnSurface,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.lgBorder),
                    ),
                  ),
                  child: const Text('Get started'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
