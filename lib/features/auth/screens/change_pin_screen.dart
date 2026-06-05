import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/services/auth/unlock_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../viewmodels/change_pin_viewmodel.dart';
import '../widgets/passcode_dots_indicator.dart';
import '../widgets/passcode_keypad.dart';

/// AUTH-007 — change PIN screen.
class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final ChangePinViewModel _vm = ChangePinViewModel();
  bool _shake = false;
  String? _statusOverride;

  @override
  void initState() {
    super.initState();
    _vm.completed$.listen((done) {
      if (done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN updated.'),
            duration: Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    });
    _vm.error$.listen((err) {
      if (err == null || !mounted) return;
      HapticFeedback.heavyImpact();
      setState(() {
        _shake = true;
        _statusOverride = switch (err) {
          'wrong' => 'Wrong current PIN. Try again.',
          'mismatch' => 'PINs did not match. Try again.',
          _ => 'Try again.',
        };
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) setState(() => _shake = false);
      });
    });
    _vm.result$.listen((r) {
      if (r is UnlockLockedOut && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Too many wrong attempts. Try again in ${r.remaining.inSeconds}s.',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  String _titleFor(ChangePinStep step) => switch (step) {
        ChangePinStep.current => 'Enter current PIN',
        ChangePinStep.create => 'Pick a new PIN',
        ChangePinStep.confirm => 'Confirm new PIN',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Change PIN'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              StreamBuilder<ChangePinStep>(
                stream: _vm.step$,
                initialData: _vm.step$.value,
                builder: (context, snap) => Text(
                  _titleFor(snap.data ?? ChangePinStep.current),
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (_statusOverride != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _statusOverride!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              StreamBuilder<String>(
                stream: _vm.buffer$,
                initialData: '',
                builder: (context, snap) => AnimatedSlide(
                  offset: _shake ? const Offset(0.05, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 80),
                  child: PasscodeDotsIndicator(
                    length: SecurityConstants.kPinLength,
                    filled: (snap.data ?? '').length,
                  ),
                ),
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
    );
  }
}
