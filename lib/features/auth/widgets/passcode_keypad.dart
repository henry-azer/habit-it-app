import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// AUTH-002 — 3x4 numeric keypad for PIN entry.
///
/// Port of `vault-it-app/lib/features/security/presentation/widgets/passcode_keypad.dart`
/// adapted to Habit-It's theme tokens (`AppColors`, `AppSpacing`, `AppRadius`).
///
/// Layout (top to bottom):
///   row 1: 1 2 3
///   row 2: 4 5 6
///   row 3: 7 8 9
///   row 4: [biometric|empty]  0  [backspace]
///
/// Haptics: `lightImpact` on digit (here), `mediumImpact` on backspace (here).
/// `heavyImpact` on wrong-PIN is the caller's responsibility (see LockScreen).
class PasscodeKeypad extends StatelessWidget {
  const PasscodeKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.biometricIcon = Icons.fingerprint,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final IconData biometricIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fg = isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final bg = isDark
        ? AppColors.darkSurfaceContainer
        : AppColors.lightSurfaceContainer;
    final border = isDark ? AppColors.darkOutline : AppColors.lightOutline;

    Widget buildDigit(String d) => _KeyButton(
          key: Key('passcode-digit-$d'),
          onTap: enabled ? () => _emitDigit(d) : null,
          backgroundColor: bg,
          borderColor: border,
          child: Text(
            d,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: -0.5,
            ),
          ),
        );

    final biometricCell = onBiometric != null
        ? _KeyButton(
            key: const Key('passcode-biometric'),
            onTap: enabled ? onBiometric : null,
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            child: Icon(biometricIcon, size: 28, color: fg),
          )
        : const SizedBox.shrink();

    final backspaceCell = _KeyButton(
      key: const Key('passcode-backspace'),
      onTap: enabled ? _emitBackspace : null,
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      child: Icon(Icons.backspace_outlined, size: 26, color: fg),
    );

    Widget buildRow(List<Widget> children) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children.map((c) => Expanded(child: c)).toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow([buildDigit('1'), buildDigit('2'), buildDigit('3')]),
          buildRow([buildDigit('4'), buildDigit('5'), buildDigit('6')]),
          buildRow([buildDigit('7'), buildDigit('8'), buildDigit('9')]),
          buildRow([biometricCell, buildDigit('0'), backspaceCell]),
        ],
      ),
    );
  }

  void _emitDigit(String d) {
    HapticFeedback.lightImpact();
    onDigit(d);
  }

  void _emitBackspace() {
    HapticFeedback.mediumImpact();
    onBackspace();
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
  });

  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 72,
        height: 72,
        child: Material(
          color: backgroundColor,
          shape: CircleBorder(
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// `BorderRadius` helper for callers that want a non-circular keypad style.
/// Not used by the default `_KeyButton` (which is circular) but exposed for
/// future variants.
const BorderRadius kPasscodeKeyRadius =
    BorderRadius.all(Radius.circular(AppRadius.pillBorder));
