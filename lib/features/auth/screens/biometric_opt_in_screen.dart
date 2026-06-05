import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../viewmodels/biometric_signin_viewmodel.dart';

/// AUTH-004 — biometric opt-in screen.
///
/// AC#1: auto-skips when the device cannot perform biometric auth.
/// AC#2: on Enable, prompts `local_auth.authenticate(stickyAuth: true)` via
/// `IBiometricManager`; on success persists `isBiometricAuthenticated=true`.
/// AC#3: Skip CTA invokes `onSkip()` without persisting anything.
class BiometricOptInScreen extends StatefulWidget {
  const BiometricOptInScreen({
    super.key,
    required this.onEnabled,
    required this.onSkip,
    this.reason = 'Authenticate to enable biometric unlock',
    this.title = 'Quicker unlock',
    this.subtitle =
        'Use your fingerprint or face to unlock Habit-It in one tap.\nYou can change this later in Settings.',
  });

  final VoidCallback onEnabled;
  final VoidCallback onSkip;
  final String reason;
  final String title;
  final String subtitle;

  @override
  State<BiometricOptInScreen> createState() => _BiometricOptInScreenState();
}

class _BiometricOptInScreenState extends State<BiometricOptInScreen> {
  final BiometricSigninViewModel _vm = BiometricSigninViewModel();
  bool _autoSkipped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _probeAndMaybeSkip());
  }

  Future<void> _probeAndMaybeSkip() async {
    await _vm.probe();
    if (!mounted) return;
    final available = _vm.available$.value;
    if (available == false && !_autoSkipped) {
      _autoSkipped = true;
      widget.onSkip();
    }
  }

  Future<void> _enable() async {
    HapticFeedback.lightImpact();
    final ok = await _vm.optIn(reason: widget.reason);
    if (!mounted) return;
    if (ok) {
      widget.onEnabled();
    } else {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(
          content: Text('Biometric authentication was not completed.'),
          duration: Duration(seconds: 2),
        ));
    }
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const Spacer(),
              Icon(
                Icons.fingerprint,
                size: 88,
                color: AppColors.accentDefault,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const Spacer(),
              StreamBuilder<bool>(
                stream: _vm.attempting$,
                initialData: false,
                builder: (context, snap) {
                  final busy = snap.data ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: busy ? null : _enable,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentDefault,
                          foregroundColor: AppColors.darkOnSurface,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.lgBorder),
                          ),
                        ),
                        child: busy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Enable biometric unlock'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: busy ? null : widget.onSkip,
                        child: const Text('Not now'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
