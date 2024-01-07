import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/features/habit/habit/presentation/widgets/habit-item/habit_list_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/date_util.dart';
import '../../../../../core/widgets/title/title_divider_widget.dart';
import '../widgets/app-bar/calendar_app_bar_widget.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({Key? key}) : super(key: key);

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> with WidgetsBindingObserver {
  final String _currentMonthString = DateUtil.convertDateToMonthString(DateUtil.getTodayDate());
  final DateTime _firstDate = DateUtil.getFirstDayOfCurrentMonth();
  late DateTime _selectedDate = DateUtil.getTodayDate();
  final DateTime _todayDate = DateUtil.getTodayDate();

  late HabitLocalDataSource _habitLocalDataSource;
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _initServices();
    _loadHabits();
  }

  _initServices() async {
    _habitLocalDataSource = GetIt.instance<HabitLocalDataSource>();
  }

  _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDate = newDate;
    });
    await _loadHabits();
  }

  _loadHabits() async {
    final habits = await _habitLocalDataSource.getHabitsByDay(_selectedDate, _currentMonthString);
    await _habitLocalDataSource.updateHabitsStats(habits, _selectedDate, _currentMonthString);
    setState(() {
      _habits = habits;
    });
  }

  _navigateToAddHabit() async {
    Object? result = await Navigator.pushNamed(context, Routes.appHabitAdd);
    if (result is bool && result) {
      await _loadHabits();
    }
  }

  _reorderHabit(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final habit1 = _habits[oldIndex];
    final habit2 = _habits[newIndex];
    setState(() {
      final habit = _habits.removeAt(oldIndex);
      _habits.insert(newIndex, habit);
    });
    await _habitLocalDataSource.reorderHabit(
        habit1, habit2, _currentMonthString);
  }

  _removeHabit(Habit habit) {
    AppNotifier.showDeleteActionDialog(
        context: context,
        message: AppLocalizationHelper.translate(
            context, AppLocalizationKeys.areYouSure),
        descriptionMessage: "${AppLocalizationHelper.translate(context, AppLocalizationKeys.remove)} `${habit.name}` ${AppLocalizationHelper.translate(context, AppLocalizationKeys.habit)}",
        onClickYes: () async {
          await _habitLocalDataSource.removeHabit(habit, _currentMonthString);
          await _loadHabits();
          Navigator.of(context).pop();
        });
  }

  Widget _buildHabitList() {
    if (_habits.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.11,
              ),
              Image.asset(
                AppImageAssets.emptyHabits,
                width: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.noHabitsForThisDay),
                style: AppTextStyles.noHabitsTextTitle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.tryToAddSome),
                style: AppTextStyles.noHabitsTextSubtitle,
              ),
            ],
          ),
        ),
      );
    }

    return HabitListWidget(
      habits: _habits,
      onReorder: (oldIndex, newIndex) async {
        await _reorderHabit(oldIndex, newIndex);
      },
      onPressAction: (habit) async {
        await _habitLocalDataSource.toggleHabitStatus(
            habit, _selectedDate.day, _currentMonthString);
        await _loadHabits();
      },
      onPressRemove: (habit) async {
        await _removeHabit(habit);
      },
      onPressSave: (habit) async {
        await _habitLocalDataSource.updateHabit(habit, _currentMonthString);
        await _loadHabits();
      },
      selectedDay: _selectedDate.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: CalendarAppBar(
          locale: 'EN',
          selectedDate: _todayDate,
          firstDate: _firstDate,
          lastDate: _todayDate,
          onDateChanged: _onDateChanged,
          black: AppColors.black,
          accent: AppColors.accent,
          fontColor: AppColors.fontPrimary,
          white: AppColors.secondary.withOpacity(0.9),
          events: [_todayDate],
        ),
        body: Column(
          children: [
            if (_habits.isNotEmpty) ...{
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: TitleDividerWidget(
                  text: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.habits),
                ),
              ),
            },
            Expanded(child: _buildHabitList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _navigateToAddHabit();
          },
          child: const Icon(LineAwesomeIcons.pushed),
        ),
      ),
    );
  }
}
