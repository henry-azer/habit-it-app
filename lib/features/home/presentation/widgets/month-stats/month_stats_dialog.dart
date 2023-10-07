import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/features/home/presentation/widgets/month-stats/month_stats_item_widget.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../data/entities/habit_stats.dart';

class MonthStatsDialog extends StatefulWidget {
  final List<HabitStats> monthHabits;

  const MonthStatsDialog({Key? key, required this.monthHabits})
      : super(key: key);

  @override
  State<MonthStatsDialog> createState() => _MonthStatsDialogState();
}

class _MonthStatsDialogState extends State<MonthStatsDialog> {
  @override
  Widget build(BuildContext context) {
    List<HabitStats> habits = widget.monthHabits;

    return CupertinoTheme(
      data:  CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.background,
        scaffoldBackgroundColor: AppColors.background,
      ),
      child: CupertinoAlertDialog(
        title: Text(
          "Month Habits Progress",
          style: AppTextStyles.alertDialogTitle,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 25.0, bottom: 5.0),
          child: Column(
            children: habits
                .map((habit) => MonthStatsItemWidget(
                      name: habit.name,
                      total: habit.total,
                      totalDone: habit.totalDone,
                    ))
                .toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.black,
              textStyle: AppTextStyles.alertDialogActionButton,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
