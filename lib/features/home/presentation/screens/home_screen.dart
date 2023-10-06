import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';

import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/date_util.dart';
import '../widgets/app-bar/calendar_app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final DateTime _firstDate = DateUtil.getFirstDayOfCurrentMonth();
  final DateTime _todayDate = DateUtil.getTodayDate();
  late DateTime _selectedDate = DateUtil.getTodayDate();

  late HabitLocalDataSource _habitLocalDataSource;
  late bool _isCurrentMonthInitialized;
  List<String> _months = [];

  @override
  void initState() {
    super.initState();
    _initHabitLocalDataSource();
    _initHabitLocalData();
  }

  _initHabitLocalDataSource() async {
    _habitLocalDataSource =  GetIt.instance<HabitLocalDataSource>();
  }

  _initHabitLocalData() async {
    _isCurrentMonthInitialized = await _habitLocalDataSource.getIsCurrentMonthInitialized();
    if (!_isCurrentMonthInitialized) {
      await _habitLocalDataSource.prepareMonthData();
    }

    List<String> months = await _habitLocalDataSource.getHabitMonths();
    log(months.toString());
    setState(() {
      _months = months;
    });

  }

  void onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
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
          onDateChanged: onDateChanged,
          black: AppColors.black,
          accent: AppColors.accent,
          fontColor: AppColors.fontPrimary,
          white: AppColors.secondary.withOpacity(0.9),
          events: [_todayDate],
        ),
        body: Center(
          child: _buildDayTasks(),
        ),
      ),
    );
  }

  Widget _buildDayTasks() {
    return Text(
      "Day Page - ${_selectedDate.toLocal()} \nfirst - ${DateUtil.getFirstDayOfCurrentMonth()} \n${_months.toString()}",
      style: AppTextStyles.homeText,
    );
  }
}
