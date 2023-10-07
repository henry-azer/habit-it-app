import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
import 'package:habit_it/features/home/presentation/widgets/floating-action-button/floating_speed_dial_child.dart';
import 'package:habit_it/features/home/presentation/widgets/habit-item/habit_item_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/date_util.dart';
import '../widgets/add-habit/add_habit_dialog.dart';
import '../widgets/app-bar/calendar_app_bar_widget.dart';
import '../widgets/floating-action-button/floating_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final String _currentMonthString = DateUtil.getCurrentMonthDateString();

  final DateTime _firstDate = DateUtil.getFirstDayOfCurrentMonth();
  final DateTime _todayDate = DateUtil.getTodayDate();

  late String _selectedDateString = DateUtil.convertDateToString(DateUtil.getTodayDate());

  late HabitLocalDataSource _habitLocalDataSource;
  late bool _isCurrentMonthInitialized;
  Map<String, bool> _habits = {};

  @override
  void initState() {
    super.initState();
    _initHabitLocalDataSource();
    _initHabitLocalData();
  }

  _initHabitLocalDataSource() async {
    _habitLocalDataSource = GetIt.instance<HabitLocalDataSource>();
  }

  _initHabitLocalData() async {
    _isCurrentMonthInitialized =
        await _habitLocalDataSource.getIsCurrentMonthInitialized();
    if (!_isCurrentMonthInitialized) {
      await _habitLocalDataSource.prepareMonthData();
    }
    await _loadHabits();
  }

  _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDateString = DateUtil.convertDateToString(newDate);
    });
    await _loadHabits();
  }

  _loadHabits() async {
    Map<String, bool> habits = await _habitLocalDataSource.getAllMonthHabitsForDay(
        _currentMonthString, _selectedDateString);
    setState(() {
      _habits = habits;
    });
  }

  _addHabit() async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AddHabitDialog(
          onAddHabit: (habitName) async {
            await _habitLocalDataSource.addHabitToCurrentMonth(habitName, _selectedDateString);
            await _loadHabits();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _markHabit(String habitName) async {
    await _habitLocalDataSource.toggleHabitStatus(habitName, _currentMonthString, _selectedDateString);
    await _loadHabits();
  }

  _removeHabit(String habitName) {
    AppNotifier.showActionDialog(
        context: context,
        message: "Are you sure?",
        onClickYes: () async {
          await _habitLocalDataSource.removeHabit(habitName, _currentMonthString, _selectedDateString);
          await _loadHabits();
          Navigator.of(context).pop();
        });
  }

  Widget _buildHabitList() {
    if (_habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No habits added for this month.",
              style: AppTextStyles.noHabitsTextTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Try to add some.",
              style: AppTextStyles.noHabitsTextSubtitle,
            ),
          ],
        ),
      );
    }

    List<Widget> habitWidgets = [];
    for (MapEntry<String, bool> habit in _habits.entries) {
      habitWidgets.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            HabitItemWidget(
              title: habit.key,
              isDone: habit.value,
              onPressRemove: () {
                _removeHabit(habit.key);
              },
              onPressAction: () {
                _markHabit(habit.key);
              },
            ),
          ],
        ),
      );
    }

    habitWidgets.add(
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(children: habitWidgets),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: CalendarAppBar(
          locale: 'en',
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
        body: _buildHabitList(),
        floatingActionButton: FloatingSpeedDial(
          labelsBackgroundColor: AppColors.accent,
          labelsStyle: AppTextStyles.floatingSpeedDialChild,
          speedDialChildren: <FloatingSpeedDialChild>[
            FloatingSpeedDialChild(
              child: const Icon(LineAwesomeIcons.pushed),
              foregroundColor: AppColors.black,
              backgroundColor: AppColors.secondary.withOpacity(0.9),
              label: 'Add Habit',
              onPressed: _addHabit,
            ),
            FloatingSpeedDialChild(
              child: const Icon(LineAwesomeIcons.rocket),
              foregroundColor: AppColors.black,
              backgroundColor: AppColors.secondary.withOpacity(0.9),
              label: 'Month Stats',
              onPressed: () {},
            ),
          ],
          openForegroundColor: AppColors.secondary.withOpacity(0.9),
          openBackgroundColor: AppColors.accent,
          closedBackgroundColor: AppColors.secondary.withOpacity(0.9),
          closedForegroundColor: AppColors.black,
          child: const Icon(LineAwesomeIcons.list),
        ),
      ),
    );
  }
}
