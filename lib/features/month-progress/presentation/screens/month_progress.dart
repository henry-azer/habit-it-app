import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../data/entities/habit_progress.dart';

class MonthProgressScreen extends StatefulWidget {
  const MonthProgressScreen({Key? key}) : super(key: key);

  @override
  State<MonthProgressScreen> createState() => _MonthProgressScreenState();
}

class _MonthProgressScreenState extends State<MonthProgressScreen> {
  late HabitStatsLocalDataSource _habitStatsLocalDataSource;
  late UserLocalDataSource _userLocalDataSource;
  late List<HabitProgress> _monthHabits = [];
  late List<int> _habitsTotalValues = [];
  late DateTime _month = DateTime.now();
  late int _monthDaysCount = 0;
  late String _username = '';

  @override
  void initState() {
    super.initState();
    _initLocalDataSources();
    _initLocalData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  _initLocalDataSources() async {
    _userLocalDataSource = GetIt.instance<UserLocalDataSource>();
    _habitStatsLocalDataSource = GetIt.instance<HabitStatsLocalDataSource>();
  }

  _initLocalData() async {
    String username = await _userLocalDataSource.getUsername();
    List<HabitProgress> monthHabits = await _habitStatsLocalDataSource
        .getMonthHabitsProgress(DateUtil.convertDateToMonthString(_month));

    setState(() {
      _username = username;
      _monthHabits = monthHabits;
    });

    List<int> habitsTotalValues = [];
    for (var habit in _monthHabits) {
      int total = 0;
      for (var value in habit.values.values) {
        if (value) {
          total++;
        }
      }
      habitsTotalValues.add(total);
    }

    setState(() {
      _habitsTotalValues = habitsTotalValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime month = ModalRoute.of(context)?.settings.arguments as DateTime;
    int monthDaysCount = DateUtil.countDaysOfMonth(month);
    setState(() {
      _month = month;
      _monthDaysCount = monthDaysCount;
    });
    return MaterialApp(
      home: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: AppColors.background,
        body: _buildBody(month),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(LineAwesomeIcons.angle_left)),
      backgroundColor: AppColors.background,
      centerTitle: true,
      title: Row(
        children: <Widget>[
          const Spacer(),
          Text(
            DateFormat.yMMMM().format(_month).toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
          const Spacer(),
          ...{
            Text(
              _username,
              style: const TextStyle(fontSize: 16.0),
            ),
          },
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget _buildBody(DateTime month) {
    return SafeArea(
      child: Center(
        child: _monthHabits.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No habits added for this month.",
                    style: AppTextStyles.noHabitsTextTitle,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: 20,
                      border: TableBorder.all(
                        width: 0.5,
                        color: AppColors.secondary,
                      ),
                      columnSpacing: 0,
                      columns: [
                        DataColumn(
                          label: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              'Habit',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.fontPrimary),
                            ),
                          ),
                        ),
                        for (int day = 1; day <= _monthDaysCount; day++)
                          DataColumn(
                            label: Text(
                              day < 10 ? '  $day ' : ' $day ',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.fontPrimary),
                            ),
                          ),
                        DataColumn(
                          numeric: true,
                          label: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.fontPrimary),
                            ),
                          ),
                        ),
                      ],
                      rows: _monthHabits.asMap().entries.map((entry) {
                        int index = entry.key;
                        HabitProgress habit = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                  "${habit.name.substring(0, habit.name.length - 5)}   ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.fontPrimary)),
                            ),
                            for (int day = 1; day <= _monthDaysCount; day++)
                              DataCell(
                                habit.values[day] == true
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.check,
                                            size: 12.0, color: AppColors.green),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.close,
                                            size: 12.0, color: AppColors.red),
                                      ),
                                placeholder: false,
                                showEditIcon: false,
                              ),
                            DataCell(
                              Text(
                                "   ${_habitsTotalValues[index]}/$_monthDaysCount",
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.fontPrimary),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
