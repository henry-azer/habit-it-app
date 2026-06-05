import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/auth/auth_migrator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'passcode_setup_screen.dart';

/// PO G-003 — dedicated screen for legacy 5-digit PIN holders to pick their
/// new 4-digit PIN.
///
/// **Non-negotiable per PO:**
///   - explicit "We've upgraded PIN security" copy,
///   - reuses the AUTH-003 two-phase setup widget internally,
///   - does NOT chain into the biometric opt-in afterward,
///   - routes directly to `/app/habits` on success + shows a confirmation snackbar.
class PasscodeUpgradeScreen extends StatelessWidget {
  const PasscodeUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.md),
          decoration: BoxDecoration(
            color: context.isDark
                ? AppColors.darkSurfaceContainer
                : AppColors.lightSurfaceContainer,
          ),
          width: double.infinity,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We've upgraded PIN security",
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Habit-It now uses a 4-digit PIN with stronger encryption. '
                  'Pick a new PIN below to continue.',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PasscodeSetupScreen(
            title: 'Update your PIN',
            subtitle: 'Choose a new 4-digit PIN.',
            onComplete: () async {
              await getIt<AuthMigrator>().finalize();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN updated.'),
                  duration: Duration(seconds: 2),
                ),
              );
              context.go(AppRoutes.habitsPath);
            },
            onBack: () {
              // Block back navigation while migration is pending — if they
              // dismiss, return to the prompt.
              context.go(AppRoutes.signupPinMigratePath);
            },
          ),
        ),
      ],
    );
  }
}
