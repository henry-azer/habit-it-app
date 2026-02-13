import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:habit_it/data/dtos/habit_progress.dart';
import 'package:intl/intl.dart';

import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/widgets/appbar/header_widget.dart';
import '../../../../../../data/enums/habit_state.dart';

class HabitMonthProgressScreen extends StatefulWidget {
  final DateTime date;

  const HabitMonthProgressScreen({Key? key, required this.date})
      : super(key: key);

  @override
  State<HabitMonthProgressScreen> createState() =>
      _HabitMonthProgressScreenState();
}

class _HabitMonthProgressScreenState extends State<HabitMonthProgressScreen> {
  late HabitStatsLocalDataSource _habitStatsLocalDataSource;
  late List<HabitProgress> _habitsProgress = [];
  late int _monthDaysCount = 0;

  @override
  void initState() {
    super.initState();
    _initServices();
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

  _initServices() {
    _habitStatsLocalDataSource = GetIt.instance<HabitStatsLocalDataSource>();
  }

  _initLocalData() async {
    int monthDaysCount = DateUtil.countDaysOfMonth(widget.date);
    List<HabitProgress> habitsProgress =
        await _habitStatsLocalDataSource.getHabitsProgressByMonth(
            DateUtil.convertDateToMonthString(widget.date));
    setState(() {
      _habitsProgress = habitsProgress;
      _monthDaysCount = monthDaysCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            HeaderWidget(
              onPressBack: () {
                Navigator.of(context).pop();
              },
              title: DateFormat.yMMMM().format(widget.date).toString(),
              backButton: true,
              height: 75,
              paddingLeft: 0.05,
              titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold) ?? const TextStyle(),
            ),
            if (_habitsProgress.isEmpty) ...{
              Column(
                children: [
                  SizedBox(
                    height: context.height * 0.12,
                  ),
                  Image.asset(
                    AppImageAssets.emptyHabits,
                    width: 170,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppStrings.noHabitsForThisMonth.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            },
            const SizedBox(height: 10),
            if (_habitsProgress.isNotEmpty) ...{
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: 20,
                          border: TableBorder.all(
                            width: 0.5,
                            color: Theme.of(context).dividerColor,
                          ),
                          columnSpacing: 0,
                          columns: [
                            DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  AppStrings.habit.tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyMedium?.color),
                                ),
                              ),
                            ),
                            for (int day = 1; day <= _monthDaysCount; day++)
                              DataColumn(
                                label: Text(
                                  day < 10 ? '  $day ' : ' $day ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyMedium?.color),
                                ),
                              ),
                            DataColumn(
                              numeric: true,
                              label: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  AppStrings.total.tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyMedium?.color),
                                ),
                              ),
                            ),
                          ],
                          rows: _habitsProgress.asMap().entries.map((entry) {
                            HabitProgress habitProgress = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text("${habitProgress.name}    ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).textTheme.bodyMedium?.color)),
                                ),
                                for (int day = 1; day <= _monthDaysCount; day++)
                                  if (habitProgress.daysStates[day] ==
                                      HabitState.DONE) ...{
                                    DataCell(
                                      placeholder: false,
                                      showEditIcon: false,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.check,
                                            size: 12.0, color: AppColors.success),
                                      ),
                                    ),
                                  } else if (habitProgress.daysStates[day] == HabitState.NOT_DONE) ...{
                                    DataCell(
                                      placeholder: false,
                                      showEditIcon: false,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.close,
                                            size: 12.0, color: AppColors.error),
                                      ),
                                    ),
                                  } else ...{
                                    DataCell(
                                      placeholder: false,
                                      showEditIcon: false,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.remove,
                                            size: 12.0,
                                            color: (habitProgress.daysStates[day] != HabitState.SUSPENDED)
                                                ? AppColors.darkTextSecondary
                                                : AppColors.error),
                                      ),
                                    ),
                                  },
                                DataCell(
                                  Text(
                                    "   ${habitProgress.totalDone}/${habitProgress.total}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodyMedium?.color),
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
              ),
            },
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
