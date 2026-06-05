import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/hive_box_keys.dart';
import '../../../core/constants/security_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/managers/biometric/i_biometric_manager.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/auth/app_lock_service.dart';
import '../../../core/services/auth/unlock_result.dart';
import '../../../core/services/backup/reset_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../viewmodels/passcode_signin_viewmodel.dart';
import '../widgets/passcode_dots_indicator.dart';
import '../widgets/passcode_keypad.dart';

/// AUTH-005 — lock screen.
///
/// Renders dots + keypad + status text + Forgot-PIN link. Auto-attempts
/// biometric on first frame (if available); manual biometric icon also shown
/// in the keypad's bottom-left cell.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final PasscodeSigninViewModel _vm = PasscodeSigninViewModel();
  final AppLockService _lock = getIt<AppLockService>();
  final IBiometricManager _biometric = getIt<IBiometricManager>();

  bool _shake = false;
  bool _biometricAvailable = false;
  String? _statusOverride;
  Duration? _lockoutRemaining;
  Timer? _countdownTimer;

  StreamSubscription<UnlockResult?>? _resultSub;

  @override
  void initState() {
    super.initState();
    _resultSub = _vm.result$.listen(_handleResult);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _biometricAvailable = await _biometric.isAvailable();
      if (mounted) setState(() {});
      await _refreshLockout();
      if (_lockoutRemaining == null) {
        _autoBiometric();
      }
    });
  }

  Future<void> _refreshLockout() async {
    final remaining = await _lock.getActiveLockout();
    if (!mounted) return;
    setState(() {
      _lockoutRemaining = remaining;
    });
    _countdownTimer?.cancel();
    if (remaining != null) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
        await _refreshLockout();
      });
    }
  }

  Future<void> _autoBiometric() async {
    if (!_biometricAvailable) return;
    await _vm.tryBiometric('Unlock Habit-It');
  }

  Future<void> _manualBiometric() async {
    if (!_biometricAvailable) return;
    await _vm.tryBiometric('Unlock Habit-It');
  }

  void _handleResult(UnlockResult? result) {
    if (!mounted || result == null) return;
    if (result is UnlockSuccess) {
      // GoRouter `redirect:` pops `/lock` automatically once
      // `lockedNotifier.value` flips to false (done by AppLockService).
      return;
    }
    if (result is UnlockWrong) {
      HapticFeedback.heavyImpact();
      setState(() {
        _shake = true;
        _statusOverride =
            'Wrong PIN. ${result.attemptsRemainingBeforeLockout} attempts left.';
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) setState(() => _shake = false);
      });
      return;
    }
    if (result is UnlockLockedOut) {
      HapticFeedback.heavyImpact();
      setState(() {
        _statusOverride = null;
        _lockoutRemaining = result.remaining;
      });
      _refreshLockout();
      return;
    }
    if (result is UnlockBiometricFailed) {
      setState(() => _statusOverride = 'Biometric did not match.');
      return;
    }
    if (result is UnlockBiometricUnavailable) {
      // Silent — biometric isn't usable; PIN remains.
    }
  }

  Future<void> _showForgotPin() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Habit-It?'),
        content: const Text(
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
    if (ok != true || !mounted) return;
    await getIt<ResetService>().resetAll();
    // Re-open Hive boxes so the next splash render has live boxes available.
    // (main.dart opens them on bootstrap; ResetService deletes them.)
    await Future.wait([
      Hive.openBox(HiveBoxKeys.app),
      Hive.openBox(HiveBoxKeys.user),
      Hive.openBox(HiveBoxKeys.settings),
      Hive.openBox(HiveBoxKeys.habits),
      Hive.openBox(HiveBoxKeys.notes),
      Hive.openBox(HiveBoxKeys.notificationsMeta),
      Hive.openBox(HiveBoxKeys.magicMeta),
    ]);
    // Unlock the gate; router redirect will then take splash → onboarding.
    _lock.unlockNow();
    if (!mounted) return;
    // GoRouter handles the navigation: unlockNow() flipped the gate, so the
    // redirect rule will allow `/` — but we also clear back-stack by routing
    // there explicitly.
    context.go(AppRoutes.splashPath);
  }

  @override
  void dispose() {
    _resultSub?.cancel();
    _countdownTimer?.cancel();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final statusText = _lockoutRemaining != null
        ? 'Too many attempts. Try again in ${_format(_lockoutRemaining!)}.'
        : (_statusOverride ?? 'Enter your PIN');
    final hasError = _statusOverride != null && _lockoutRemaining == null;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxxl),
                      Icon(
                        Icons.lock_outline,
                        size: 56,
                        color: AppColors.accentDefault,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl),
                        child: Text(
                          statusText,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: hasError ? AppColors.error : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (_lockoutRemaining == null)
                        StreamBuilder<String>(
                          stream: _vm.buffer$,
                          initialData: _vm.buffer$.value,
                          builder: (context, snap) => AnimatedSlide(
                            offset: _shake
                                ? const Offset(0.05, 0)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 80),
                            child: PasscodeDotsIndicator(
                              length: SecurityConstants.kPinLength,
                              filled: (snap.data ?? '').length,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.timer_outlined,
                          size: 32,
                          color: isDark
                              ? AppColors.darkOnSurfaceVariant
                              : AppColors.lightOnSurfaceVariant,
                        ),
                      const Spacer(),
                      StreamBuilder<bool>(
                        stream: _vm.processing$,
                        initialData: false,
                        builder: (context, snap) {
                          final busy = snap.data ?? false;
                          return PasscodeKeypad(
                            onDigit: _vm.onDigit,
                            onBackspace: _vm.onBackspace,
                            onBiometric: _biometricAvailable && !busy
                                ? _manualBiometric
                                : null,
                            biometricIcon: Icons.fingerprint,
                            enabled: _lockoutRemaining == null && !busy,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: _showForgotPin,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm),
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
            ),
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(1, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

