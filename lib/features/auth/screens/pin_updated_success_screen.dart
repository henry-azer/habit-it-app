import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// AUTH-008 AQ-2 (PM override) — confirmation screen reached **only** from the
/// legacy 5-digit PIN migration path after a user has set their new 4-digit PIN
/// via `PasscodeUpgradeScreen`.
///
/// Rationale (per PM_VALIDATION_R2_AUTH.md AQ-2 amendment):
///   - The migration moment is exceptional in the v1 lifecycle and the prior
///     snackbar + immediate redirect to `/app/habits` left the user without
///     reliable closure if the snackbar was dismissed or queued behind another.
///   - This screen shows a single-button confirmation with explicit copy and a
///     `Continue` CTA that routes to `/app/habits`.
///   - There is **no** biometric prompt, **no** snackbar, and **no**
///     `Forgot PIN?` link here. First-time signup (AUTH-008) and change-PIN
///     (AUTH-007) success paths are unchanged — they never reach this screen.
///
/// Reached exclusively from `PasscodeUpgradeScreen.onComplete`.
class PinUpdatedSuccessScreen extends StatelessWidget {
  const PinUpdatedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Localization: keys `auth.pin_updated_title` and `auth.pin_updated_message`
    // are added to `assets/lang/en.json` ahead of the `'key'.tr` extension
    // landing (see lib/core/theme/theme_notifier.dart:9 comment + SET-006).
    // The strings below mirror those values verbatim so the swap is mechanical
    // once the extension exists.
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
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentDefault.withValues(alpha: 0.12),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 56,
                  color: AppColors.accentDefault,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'PIN updated successfully',
                style: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your new 4-digit PIN is set. Use it the next time you open the app.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.go(AppRoutes.habitsPath);
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
                  child: const Text('Continue'),
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
