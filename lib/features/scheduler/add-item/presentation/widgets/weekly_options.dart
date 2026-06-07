import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/widgets/day-picker/model/day_in_week.dart';
import '../../../../../core/widgets/day-picker/widgets/select_day.dart';

/// Wraps the existing `SelectWeekDays` widget so the recurrence picker can
/// drop it into the add/edit form with the right defaults and a soft hint
/// when every weekday is selected (Story 2.3 AC).
class WeeklyOptions extends StatefulWidget {
  final List<String> initialDays;
  final ValueChanged<List<String>> onChanged;

  const WeeklyOptions({
    super.key,
    required this.initialDays,
    required this.onChanged,
  });

  @override
  State<WeeklyOptions> createState() => _WeeklyOptionsState();
}

class _WeeklyOptionsState extends State<WeeklyOptions> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.initialDays);
  }

  @override
  Widget build(BuildContext context) {
    final showAllDaysHint = _selected.length == 7;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerWeeklyWeekdays,
          ),
          style: TextStyle(
            color: AppColors.fontPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SelectWeekDays(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          days: DayInWeek.getWeekDaysBySelectedDays(_selected),
          border: false,
          boxDecoration:
              BoxDecoration(border: Border.all(color: AppColors.white)),
          onSelect: (values) {
            final next = values.cast<String>();
            setState(() => _selected = next);
            widget.onChanged(next);
          },
        ),
        if (showAllDaysHint) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizationHelper.translate(
              context,
              AppLocalizationKeys.schedulerWeeklyAllDaysHint,
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
