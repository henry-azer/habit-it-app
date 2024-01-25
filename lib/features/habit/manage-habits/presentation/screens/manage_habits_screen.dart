import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/core/widgets/appbar/header_widget.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
import 'package:habit_it/data/entities/habit.dart';

import '../../../../../../core/utils/app_text_styles.dart';
import '../../../../../../core/widgets/title/title_divider_widget.dart';
import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../widgets/manage_habits_list_widget.dart';

class ManageHabitsScreen extends StatefulWidget {
  final int selectedDay;

  const ManageHabitsScreen({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  State<ManageHabitsScreen> createState() => _ManageHabitsScreenState();
}

class _ManageHabitsScreenState extends State<ManageHabitsScreen> {
  final String _currentMonthString = DateUtil.convertDateToMonthString(DateUtil.getTodayDate());
  late HabitLocalDataSource _habitLocalDataSource;
  late List<Habit> _monthHabits = [];

  @override
  void initState() {
    super.initState();
    _initServices();
    _loadMonthHabits();
  }

  _initServices() async {
    _habitLocalDataSource = GetIt.instance<HabitLocalDataSource>();
  }

  _loadMonthHabits() async {
    final monthHabits =
        await _habitLocalDataSource.getHabits(_currentMonthString);
    setState(() {
      _monthHabits = monthHabits;
    });
  }

  _reorderHabit(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final habit1 = _monthHabits[oldIndex];
    final habit2 = _monthHabits[newIndex];
    setState(() {
      final habit = _monthHabits.removeAt(oldIndex);
      _monthHabits.insert(newIndex, habit);
    });
    await _habitLocalDataSource.reorderHabit(
        habit1, habit2, _currentMonthString);
  }

  _removeHabit(Habit habit) {
    AppNotifier.showDeleteActionDialog(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.areYouSure),
        descriptionMessage:
            "${AppLocalizationHelper.translate(context, AppLocalizationKeys.remove)} `${habit.name}` ${AppLocalizationHelper.translate(context, AppLocalizationKeys.habit)}",
        onClickYes: () async {
          await _habitLocalDataSource.removeHabit(habit, _currentMonthString);
          await _loadMonthHabits();
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            HeaderWidget(
              title: AppLocalizationHelper.translate(context, AppLocalizationKeys.manageHabitsTitle),
              backButton: true,
              height: 125,
              onPressBack: () {
                Navigator.of(context).pop(false);
              },
              titleStyle: AppTextStyles.headerTitle,
            ),
            if (_monthHabits.isEmpty) ...{
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: context.height * 0.2,
                  ),
                  Image.asset(
                    AppImageAssets.emptyHabits,
                    width: 170,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.noHabitsForThisMonth),
                    style: AppTextStyles.noHabitsTextTitle,
                  ),
                ],
              ),
            },
            if (_monthHabits.isNotEmpty) ...{

              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: TitleDividerWidget(
                  text: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.habits) ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TitleDividerWidget(
                  text: "$_currentMonthString-${widget.selectedDay}",
                ),
              ),
              Expanded(
                child: ManageHabitsListWidget(
                  habits: _monthHabits,
                  onReorder: (oldIndex, newIndex) async {
                    await _reorderHabit(oldIndex, newIndex);
                  },
                  onPressSave: (habit) async {
                    await _habitLocalDataSource.updateHabit(habit, _currentMonthString);
                    await _loadMonthHabits();
                  },
                  onPressSuspend: (habit) async {
                    await _habitLocalDataSource.suspendHabit(
                        habit, widget.selectedDay, _currentMonthString);
                    await _loadMonthHabits();
                  },
                  onPressUnsuspend: (habit) async {
                    await _habitLocalDataSource.unsuspendHabit(
                        habit, widget.selectedDay, _currentMonthString);
                    await _loadMonthHabits();
                  },
                  onPressRemove: (habit) async {
                    await _removeHabit(habit);
                  },
                  selectedDay: widget.selectedDay,
                ),
              )
            },
          ],
        ),
      ),
    );
  }
}
