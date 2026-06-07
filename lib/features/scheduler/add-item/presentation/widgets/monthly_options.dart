import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';

/// Day-of-month dropdown (1..31), the short-months hint, and the
/// carry-over toggle. The toggle is *always* rendered here — gating
/// per-flavor visibility is the add screen's responsibility.
class MonthlyOptions extends StatefulWidget {
  final int initialDayOfMonth;
  final bool initialCarryOverEnabled;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<bool> onCarryOverChanged;

  const MonthlyOptions({
    super.key,
    required this.initialDayOfMonth,
    required this.initialCarryOverEnabled,
    required this.onDayChanged,
    required this.onCarryOverChanged,
  });

  @override
  State<MonthlyOptions> createState() => _MonthlyOptionsState();
}

class _MonthlyOptionsState extends State<MonthlyOptions> {
  late int _day;
  late bool _carryOver;

  @override
  void initState() {
    super.initState();
    _day = widget.initialDayOfMonth;
    _carryOver = widget.initialCarryOverEnabled;
  }

  @override
  void didUpdateWidget(covariant MonthlyOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The add screen recomputes carry-over default when the kind changes; let
    // that re-flow into the toggle. The day stays pinned to whatever the user
    // last picked because there's no reason for kind-switching to reset it.
    if (oldWidget.initialCarryOverEnabled != widget.initialCarryOverEnabled) {
      _carryOver = widget.initialCarryOverEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showShortHint = _day >= 29;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerMonthlyDayOfMonth,
          ),
          style: TextStyle(
            color: AppColors.fontPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButton<int>(
            value: _day,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.accent,
            iconEnabledColor: AppColors.fontPrimary,
            style: TextStyle(color: AppColors.fontPrimary),
            items: List<int>.generate(31, (i) => i + 1)
                .map(
                  (d) => DropdownMenuItem<int>(
                    value: d,
                    child: Text(
                      '$d',
                      style: TextStyle(color: AppColors.fontPrimary),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _day = value);
              widget.onDayChanged(value);
            },
          ),
        ),
        if (showShortHint) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizationHelper.translate(
              context,
              AppLocalizationKeys.schedulerMonthlyShortMonthsHint,
            ),
            style: TextStyle(
              color: AppColors.secondaryAccent,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizationHelper.translate(
                  context,
                  AppLocalizationKeys.schedulerMonthlyCarryOverToggle,
                ),
                style: TextStyle(
                  color: AppColors.fontPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: _carryOver,
              onChanged: (value) {
                setState(() => _carryOver = value);
                widget.onCarryOverChanged(value);
              },
            ),
          ],
        ),
        Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerMonthlyCarryOverHelper,
          ),
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
