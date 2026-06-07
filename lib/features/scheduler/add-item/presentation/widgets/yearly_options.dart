import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/date_util.dart';

/// Month + day dropdowns for yearly recurrence. Days are constrained by the
/// selected month — Feb maxes at 29 (so the leap-day hint becomes
/// triggerable), others use the calendar max. (month, day) combinations
/// that aren't a valid calendar date are simply unreachable through the
/// dropdowns; the `Recurrence.yearly` factory still rejects them as defense
/// in depth.
class YearlyOptions extends StatefulWidget {
  final int initialMonth;
  final int initialDay;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onDayChanged;

  const YearlyOptions({
    super.key,
    required this.initialMonth,
    required this.initialDay,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  State<YearlyOptions> createState() => _YearlyOptionsState();
}

class _YearlyOptionsState extends State<YearlyOptions> {
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _day = widget.initialDay;
  }

  int _maxDayForMonth(int month) {
    // Special-case February to allow 29 (leap-day selectable, with hint).
    // All other months use the standard daysInMonth for a non-leap year.
    if (month == 2) return 29;
    // Use a non-leap year (2025) so Feb on year 2 already capped at 29 above.
    return DateUtil.daysInMonth(2025, month);
  }

  int _findNextLeapYear() {
    final start = DateTime.now().year;
    for (int y = start; y < start + 10; y++) {
      if (DateUtil.isLeapYear(y)) return y;
    }
    return start;
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = _maxDayForMonth(_month);
    final showLeapHint = _month == 2 && _day == 29;
    final months = List<int>.generate(12, (i) => i + 1);
    final days = List<int>.generate(maxDay, (i) => i + 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerYearlyMonth,
          ),
          style: TextStyle(
            color: AppColors.fontPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown<int>(
          value: _month,
          items: months,
          itemLabel: (m) => DateFormat.MMMM().format(DateTime(2000, m)),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _month = value;
              final newMax = _maxDayForMonth(_month);
              if (_day > newMax) _day = newMax;
            });
            widget.onMonthChanged(_month);
            widget.onDayChanged(_day);
          },
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerYearlyDay,
          ),
          style: TextStyle(
            color: AppColors.fontPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown<int>(
          value: _day,
          items: days,
          itemLabel: (d) => '$d',
          onChanged: (value) {
            if (value == null) return;
            setState(() => _day = value);
            widget.onDayChanged(value);
          },
        ),
        if (showLeapHint) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizationHelper.translate(
              context,
              AppLocalizationKeys.schedulerYearlyLeapHint,
            ).replaceFirst('{year}', '${_findNextLeapYear()}'),
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

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: AppColors.accent,
        iconEnabledColor: AppColors.fontPrimary,
        style: TextStyle(color: AppColors.fontPrimary),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: TextStyle(color: AppColors.fontPrimary),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
