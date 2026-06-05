import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// AUTH-002 AC#4 — N empty/filled circle indicator.
///
/// Port of `vault-it-app/lib/features/security/presentation/widgets/passcode_dots_indicator.dart`
/// using Habit-It's `AppColors.accentDefault` (PO G-001 green) for the filled
/// state instead of vault-it's gradient.
class PasscodeDotsIndicator extends StatelessWidget {
  const PasscodeDotsIndicator({
    super.key,
    required this.length,
    required this.filled,
    this.shake = false,
  });

  final int length;
  final int filled;
  final bool shake;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final emptyColor = isDark ? AppColors.darkOutline : AppColors.lightOutline;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.accentDefault : Colors.transparent,
            border: isFilled
                ? null
                : Border.all(color: emptyColor, width: 1.5),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color:
                          AppColors.accentDefault.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
