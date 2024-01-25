import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/core/widgets/appbar/header_widget.dart';
import 'package:habit_it/data/entities/app.dart';

import '../../../../../../config/locale/app_localization_helper.dart';
import '../../../../../../config/routes/app_routes.dart';
import '../../../../../../core/utils/app_assets_manager.dart';
import '../../../../../../core/utils/app_localization_strings.dart';
import '../../../../../../core/utils/app_text_styles.dart';
import '../../../../../../core/widgets/month-picker/month_picker.dart';
import '../../../../../../core/widgets/title/title_divider_widget.dart';
import '../../../../../../data/datasources/app/app_local_datasource.dart';
import '../widgets/habit_stats_item_widget.dart';

class HabitStatsScreen extends StatefulWidget {
  const HabitStatsScreen({Key? key}) : super(key: key);

  @override
  State<HabitStatsScreen> createState() => _HabitStatsScreenState();
}

class _HabitStatsScreenState extends State<HabitStatsScreen> {
  late AppLocalDataSource _appLocalDataSource;
  late App _appData;

  @override
  void initState() {
    super.initState();
    _initAppServices();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  _initAppServices() async {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
    final app = await _appLocalDataSource.getApp();
    setState(() {
      _appData = app;
    });
  }

  _navigateToMonthStats() async {
    DateTime? selectedDate = await showMonthPicker(
      context: context,
      firstDate: DateUtil.convertStringToDate(_appData.initDate),
      lastDate: DateUtil.convertStringToDate(_appData.lastDate),
    );
    if (selectedDate != null) {
      Navigator.pushNamed(context, Routes.appHabitMonthStats,
          arguments: selectedDate);
    }
  }

  _navigateToMonthProgress() async {
    DateTime? selectedDate = await showMonthPicker(
      context: context,
      firstDate: DateUtil.convertStringToDate(_appData.initDate),
      lastDate: DateUtil.convertStringToDate(_appData.lastDate),
    );
    if (selectedDate != null) {
      Navigator.pushNamed(context, Routes.appHabitMonthProgress,
          arguments: selectedDate);
    }
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
              title: AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.statistics),
              height: 125,
              titleStyle: AppTextStyles.headerTitle,
            ),
            Expanded(
              child: OrientationBuilder(builder: (context, orientation) {
                double containerHeight = orientation == Orientation.portrait
                    ? context.height * 0.32
                    : context.height * 0.75;
                double containerWidth = orientation == Orientation.portrait
                    ? context.width * 0.90
                    : context.width * 0.80;
                double imageWidth = orientation == Orientation.portrait
                    ? containerWidth * 0.80
                    : containerWidth * 0.50;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: TitleDividerWidget(
                          text: AppLocalizationHelper.translate(
                              context, AppLocalizationKeys.monthStats),
                        ),
                      ),
                      HabitStatsItemWidget(
                        onTap: _navigateToMonthStats,
                        containerWidth: containerWidth,
                        containerHeight: containerHeight,
                        imageAssetPath: AppImageAssets.stats,
                        imageWidth: imageWidth,
                        description: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.yourHabitMonthlyStats),
                        descriptionStyle: AppTextStyles.statsDescription,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: TitleDividerWidget(
                          text: AppLocalizationHelper.translate(
                              context, AppLocalizationKeys.monthProgress),
                        ),
                      ),
                      HabitStatsItemWidget(
                        onTap: _navigateToMonthProgress,
                        containerWidth: containerWidth,
                        containerHeight: containerHeight,
                        imageAssetPath: AppImageAssets.stats2,
                        imageWidth: imageWidth,
                        description: AppLocalizationHelper.translate(context,
                            AppLocalizationKeys.yourHabitMonthlyReport),
                        descriptionStyle: AppTextStyles.statsDescription,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
