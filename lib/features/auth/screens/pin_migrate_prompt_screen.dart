import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/auth/auth_migrator.dart';
import '../../../core/services/backup/reset_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/passcode_dots_indicator.dart';
import '../widgets/passcode_keypad.dart';

/// AUTH-001 AC#5 — legacy PIN migration prompt.
///
/// Reached from splash when `AuthMigrator.isMigrationPending()` returns true.
/// Asks the user for their legacy 5-digit PIN. On correct entry, routes to
/// [PasscodeUpgradeScreen] (PO G-003 — explicitly NOT setup, NOT biometric
/// chain). Three wrong entries → Reset Data confirm.
class PinMigratePromptScreen extends StatefulWidget {
  const PinMigratePromptScreen({super.key});

  @override
  State<PinMigratePromptScreen> createState() => _PinMigratePromptScreenState();
}

class _PinMigratePromptScreenState extends State<PinMigratePromptScreen> {
  static const int _kLegacyPinLength = 5;
  static const int _kMaxAttempts = 3;

  final StringBuffer _entered = StringBuffer();
  int _wrongAttempts = 0;
  String? _statusOverride;
  bool _shake = false;

  Future<void> _onDigit(String d) async {
    if (_entered.length >= _kLegacyPinLength) return;
    setState(() {
      _entered.write(d);
      _statusOverride = null;
    });
    if (_entered.length == _kLegacyPinLength) await _submit();
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    final s = _entered.toString();
    _entered.clear();
    _entered.write(s.substring(0, s.length - 1));
    setState(() {});
  }

  Future<void> _submit() async {
    final outcome =
        await getIt<AuthMigrator>().verifyLegacyPin(_entered.toString());
    if (!mounted) return;
    switch (outcome) {
      case MigrationOutcome.verified:
        // Don't clear legacy password yet — PasscodeUpgradeScreen does it
        // post-setup via `AuthMigrator.finalize()`.
        context.go(AppRoutes.passcodeUpgradePath);
        return;
      case MigrationOutcome.wrongPin:
        _wrongAttempts++;
        HapticFeedback.heavyImpact();
        if (_wrongAttempts >= _kMaxAttempts) {
          await _confirmReset();
        } else {
          setState(() {
            _entered.clear();
            _shake = true;
            _statusOverride =
                'Wrong PIN. ${_kMaxAttempts - _wrongAttempts} attempts left before reset.';
          });
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) setState(() => _shake = false);
          });
        }
        return;
      case MigrationOutcome.notNeeded:
        // No legacy PIN — fall through to a fresh signup.
        context.go(AppRoutes.signupWelcomePath);
        return;
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Habit-It?'),
        content: const Text(
          'You have entered the wrong PIN too many times.\n\n'
          'This permanently erases all habits, settings, and your PIN. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Erase everything'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (ok == true) {
      await getIt<ResetService>().resetAll();
      // Re-open boxes so subsequent reads succeed.
      await Future.wait([
        Hive.openBox(HiveBoxKeys.app),
        Hive.openBox(HiveBoxKeys.user),
        Hive.openBox(HiveBoxKeys.settings),
        Hive.openBox(HiveBoxKeys.habits),
        Hive.openBox(HiveBoxKeys.notes),
        Hive.openBox(HiveBoxKeys.notificationsMeta),
        Hive.openBox(HiveBoxKeys.magicMeta),
      ]);
      if (!mounted) return;
      context.go(AppRoutes.splashPath);
    } else {
      setState(() {
        _wrongAttempts = 0;
        _entered.clear();
        _statusOverride = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hasError = _statusOverride != null;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Icon(Icons.lock_clock, size: 56, color: AppColors.accentDefault),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Enter your current PIN',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _statusOverride ??
                    "We've upgraded PIN security. Verify your current 5-digit PIN to continue.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: hasError ? AppColors.error : null,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedSlide(
                offset: _shake ? const Offset(0.05, 0) : Offset.zero,
                duration: const Duration(milliseconds: 80),
                child: PasscodeDotsIndicator(
                  length: _kLegacyPinLength,
                  filled: _entered.length,
                ),
              ),
              const Spacer(),
              PasscodeKeypad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _confirmReset,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.lgBorder),
                  ),
                ),
                child: const Text('Forgot PIN?'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
