import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../viewmodels/passcode_setup_viewmodel.dart';
import '../widgets/passcode_dots_indicator.dart';
import '../widgets/passcode_keypad.dart';

/// AUTH-003 — two-phase passcode setup screen.
///
/// Reusable component: parent controls onComplete (next-route decision).
/// Used by: signup flow (chains into BiometricOptIn) AND PasscodeUpgradeScreen
/// (PO G-003 — does NOT chain into biometric).
///
/// Port of `vault-it-app/lib/features/security/presentation/screens/passcode_setup_screen.dart`
/// adapted to Habit-It's MVVM (RxDart) + FND-004 tokens.
class PasscodeSetupScreen extends StatefulWidget {
  const PasscodeSetupScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.onComplete,
    this.onBack,
  });

  /// AppBar title (e.g. "Set up PIN" / "Update your PIN").
  final String title;

  /// Optional body subtitle (e.g. "Choose a 4-digit PIN").
  final String? subtitle;

  /// Called once `vm.completed$` emits true. Caller decides routing.
  final VoidCallback onComplete;

  /// Optional override for the AppBar back button (default: Navigator.pop).
  final VoidCallback? onBack;

  @override
  State<PasscodeSetupScreen> createState() => _PasscodeSetupScreenState();
}

class _PasscodeSetupScreenState extends State<PasscodeSetupScreen> {
  final PasscodeSetupViewModel _vm = PasscodeSetupViewModel();
  bool _shake = false;

  @override
  void initState() {
    super.initState();
    _vm.completed$.listen((done) {
      if (done && mounted) widget.onComplete();
    });
    _vm.error$.listen((err) {
      if (err != null && mounted) {
        HapticFeedback.heavyImpact();
        setState(() => _shake = true);
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) setState(() => _shake = false);
        });
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            content: Text(_mismatchCopy(err)),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ));
      }
    });
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  String _mismatchCopy(String code) => switch (code) {
        'mismatch' => 'PINs did not match. Try again.',
        _ => 'Try again.',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (_vm.step$.value == PasscodeSetupStep.confirm) {
              _vm.resetToCreate();
              return;
            }
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      StreamBuilder<PasscodeSetupStep>(
                        stream: _vm.step$,
                        initialData: _vm.step$.value,
                        builder: (context, snap) {
                          final step = snap.data ?? PasscodeSetupStep.create;
                          final title = step == PasscodeSetupStep.create
                              ? 'Choose your PIN'
                              : 'Confirm your PIN';
                          return Text(
                            title,
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          );
                        },
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.subtitle!,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      StreamBuilder<String>(
                        stream: _vm.buffer$,
                        initialData: _vm.buffer$.value,
                        builder: (context, snap) {
                          return AnimatedSlide(
                            offset:
                                _shake ? const Offset(0.05, 0) : Offset.zero,
                            duration: const Duration(milliseconds: 80),
                            child: PasscodeDotsIndicator(
                              length: SecurityConstants.kPinLength,
                              filled: (snap.data ?? '').length,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      PasscodeKeypad(
                        onDigit: _vm.onDigit,
                        onBackspace: _vm.onBackspace,
                      ),
                      const SizedBox(height: AppSpacing.xl),
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
}
