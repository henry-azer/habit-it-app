import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../data/enums/recurrence_kind.dart';

/// Horizontal 5-chip recurrence selector reused by the add screen, the edit
/// screen (read-only mode), and Sprint 4.3's quick-add. Keeps the
/// presentation of the 5 flavors visually consistent across surfaces.
class RecurrenceKindPicker extends StatelessWidget {
  final RecurrenceKind selected;
  final ValueChanged<RecurrenceKind> onChanged;

  /// When false, every chip is rendered with disabled visuals and taps are
  /// no-ops. Used by the edit screen — recurrence kind is immutable after
  /// creation (changing it would orphan completionLog entries).
  final bool readOnly;

  const RecurrenceKindPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.readOnly = false,
  });

  String _labelKey(RecurrenceKind k) {
    switch (k) {
      case RecurrenceKind.oneOff:
        return AppLocalizationKeys.schedulerRecurrenceOneOff;
      case RecurrenceKind.daily:
        return AppLocalizationKeys.schedulerRecurrenceDaily;
      case RecurrenceKind.weekly:
        return AppLocalizationKeys.schedulerRecurrenceWeekly;
      case RecurrenceKind.monthlyByDay:
        return AppLocalizationKeys.schedulerRecurrenceMonthly;
      case RecurrenceKind.yearly:
        return AppLocalizationKeys.schedulerRecurrenceYearly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RecurrenceKind.values.map((kind) {
          final isSelected = kind == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(
                AppLocalizationHelper.translate(context, _labelKey(kind)),
                style: TextStyle(
                  color: isSelected
                      ? AppColors.fontSecondary
                      : AppColors.fontPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.secondary,
              backgroundColor: AppColors.accent,
              onSelected: readOnly
                  ? null
                  : (chosen) {
                      if (chosen) onChanged(kind);
                    },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: AppColors.border, width: 1.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
