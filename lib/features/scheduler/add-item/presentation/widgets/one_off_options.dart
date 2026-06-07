import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/date_util.dart';
import '../../../../../core/widgets/month-picker/month_picker.dart';

/// Date field for one-off recurrences. Tap opens the existing MonthPicker
/// (year + month) and then a sheet of valid days for that month — matches
/// the app's visual vocabulary instead of the Material `showDatePicker`.
class OneOffOptions extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;
  final String? lockHint;

  const OneOffOptions({
    super.key,
    required this.date,
    required this.onChanged,
    this.enabled = true,
    this.lockHint,
  });

  Future<void> _pickDate(BuildContext context) async {
    // Allow back-dating (Story 2.1 AC) and forward-dating up to 5 years.
    final firstDate = DateTime(date.year - 5, 1);
    final lastDate = DateTime(date.year + 5, 12);
    final pickedMonth = await showMonthPicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedMonth == null) return;
    if (!context.mounted) return;
    final pickedDay = await _showDayPicker(context, pickedMonth);
    if (pickedDay == null) return;
    onChanged(DateTime(pickedMonth.year, pickedMonth.month, pickedDay));
  }

  Future<int?> _showDayPicker(
    BuildContext context,
    DateTime month,
  ) async {
    final maxDay = DateUtil.daysInMonth(month.year, month.month);
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.accent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              children: List<int>.generate(maxDay, (i) => i + 1).map((day) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton(
                    onPressed: () => Navigator.pop(sheetContext, day),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.fontSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text('$day'),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat.yMMMMd().format(date);
    final today = DateUtil.getTodayDate();
    final normalized = DateTime(date.year, date.month, date.day);
    final isPast = normalized.isBefore(today);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerOneOffDate,
          ),
          style: TextStyle(
            color: AppColors.fontPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? () => _pickDate(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled ? AppColors.border : AppColors.grey,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatted,
                  style: TextStyle(
                    color: enabled ? AppColors.fontPrimary : AppColors.grey,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: enabled ? AppColors.fontPrimary : AppColors.grey,
                ),
              ],
            ),
          ),
        ),
        if (lockHint != null) ...[
          const SizedBox(height: 8),
          Text(
            lockHint!,
            style: TextStyle(
              color: AppColors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
        if (enabled && isPast) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizationHelper.translate(
              context,
              AppLocalizationKeys.schedulerOneOffPastDateHint,
            ),
            style: TextStyle(
              color: AppColors.secondaryAccent,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
