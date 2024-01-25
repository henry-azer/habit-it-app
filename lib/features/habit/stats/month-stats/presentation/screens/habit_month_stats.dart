import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/locale/app_localization_helper.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_localization_strings.dart';
import '../../../../../../core/utils/app_text_styles.dart';
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
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            HeaderWidget(
              onPressBack: () {
                Navigator.of(context).pop();
              },
              title: DateFormat.yMMMM().format(widget.date).toString(),
              backButton: true,
              height: 125,
              titleStyle: AppTextStyles.headerTitle2,
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
                    AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.noHabitsForThisMonth),
                    style: AppTextStyles.noHabitsTextTitle,
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
                          text: AppLocalizationHelper.translate(
                              context, AppLocalizationKeys.habits),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 20),
                        child: TitleDividerWidget(
                          text:
                              '${AppLocalizationHelper.translate(context, AppLocalizationKeys.totalHabits)} ${_habitsStats.length}',
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            dataRowHeight: 40,
                            border: TableBorder.all(
                              width: 0.5,
                              color: AppColors.secondary,
                            ),
                            columnSpacing: 0,
                            columns: [
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 45.0),
                                  child: Text(
                                    "${AppLocalizationHelper.translate(context, AppLocalizationKeys.habitName)}      ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.fontPrimary),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    AppLocalizationHelper.translate(
                                        context, AppLocalizationKeys.totalDone),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.fontPrimary),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    AppLocalizationHelper.translate(
                                        context, AppLocalizationKeys.totalNot),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.fontPrimary),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '        ${AppLocalizationHelper.translate(context, AppLocalizationKeys.total)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.fontPrimary),
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
                                            color: AppColors.fontPrimary)),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "${habit.totalDone}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.green),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        " ${habit.total - habit.totalDone}",
                                        style: TextStyle(
                                            fontSize: 12, color: AppColors.red),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "       ${habit.total}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.fontPrimary),
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
