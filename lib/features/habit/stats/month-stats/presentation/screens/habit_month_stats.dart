import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:intl/intl.dart';

import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/widgets/appbar/header_widget.dart';
import '../../../../../../core/widgets/title/title_divider_widget.dart';
import '../../../../../../data/dtos/habit_stats.dart';

class HabitMonthStatsScreen extends StatefulWidget {
  final DateTime date;

  const HabitMonthStatsScreen({Key? key, required this.date}) : super(key: key);

  @override
  State<HabitMonthStatsScreen> createState() => _HabitMonthStatsScreenState();
}

class _HabitMonthStatsScreenState extends State<HabitMonthStatsScreen> {
  late HabitStatsLocalDataSource _habitStatsLocalDataSource;
  late List<HabitStats> _habitsStats = [];

  @override
  void initState() {
    super.initState();
    _initServices();
    _initLocalData();
  }

  _initServices() {
    _habitStatsLocalDataSource = GetIt.instance<HabitStatsLocalDataSource>();
  }

  _initLocalData() async {
    final List<HabitStats> habitsStats = await _habitStatsLocalDataSource
        .getHabitsStatsByMonth(DateUtil.convertDateToMonthString(widget.date));
    setState(() {
      _habitsStats = habitsStats;
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
              height: 125,
              titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold) ?? const TextStyle(),
            ),
            if (_habitsStats.isEmpty) ...{
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
                    AppStrings.noHabitsForThisMonth.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            },
            if (_habitsStats.isNotEmpty) ...{
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 8),
                        child: TitleDividerWidget(
                          text: AppStrings.habits.tr,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 20),
                        child: TitleDividerWidget(
                          text:
                              '${AppStrings.totalHabits.tr} ${_habitsStats.length}',
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            dataRowHeight: 40,
                            border: TableBorder.all(
                              width: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                            columnSpacing: 0,
                            columns: [
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 45.0),
                                  child: Text(
                                    "${AppStrings.habitName.tr}      ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    AppStrings.totalDone.tr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    AppStrings.totalNot.tr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '        ${AppStrings.total.tr}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.bodyMedium?.color),
                                ),
                              ),
                            ],
                            rows: _habitsStats.map((habit) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text("${habit.name}  ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).textTheme.bodyMedium?.color)),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "${habit.totalDone}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.success),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        " ${habit.total - habit.totalDone}",
                                        style: TextStyle(
                                            fontSize: 12, color: AppColors.error),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "       ${habit.total}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).textTheme.bodyMedium?.color),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}
