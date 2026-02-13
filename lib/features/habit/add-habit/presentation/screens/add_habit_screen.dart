import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/core/widgets/appbar/header_widget.dart';
import 'package:habit_it/core/widgets/day-picker/model/day_in_week.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';

import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_notifier.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import '../../../../../../core/validation/validation_types.dart';
import '../../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../../core/widgets/day-picker/widgets/select_day.dart';
import '../../../../../../core/widgets/forms/text_field_widget.dart';
import '../../../../../../core/widgets/title/title_divider_widget.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late HabitLocalDataSource _habitLocalDataSource;
  late List<String> repeatDays = [];
  late String habitName = "";

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  _initServices() async {
    _habitLocalDataSource = GetIt.instance<HabitLocalDataSource>();
  }

  _submitHabitFrom() async {
    if (habitName.isEmpty) {
      AppNotifier.showSnackBar(
          context: context,
          message: AppStrings.habitNameRequired.tr);
      return;
    }

    bool isSaved = false;
    try {
      final String currentMonthString =
          DateUtil.convertDateToMonthString(DateUtil.getTodayDate());
      await _habitLocalDataSource.addHabit(
          habitName, repeatDays, currentMonthString);
      isSaved = true;
    } catch (exception) {
      return;
    }

    if (isSaved) {
      Navigator.of(context).pop(true);
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
              title: AppStrings.habit.tr.toUpperCase(),
              backButton: true,
              height: 125,
              onPressBack: () {
                Navigator.of(context).pop(false);
              },
              titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold) ?? const TextStyle(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TitleDividerWidget(
                        text: AppStrings.createNewHabit.tr,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      AppImageAssets.addHabit,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TitleDividerWidget(
                        text: AppStrings.habitName.tr,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: TextFieldWidget(
                        enabled: true,
                        hintText: AppStrings.habitName.tr,
                        hintTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        validateType: ValidationTypes.signupName,
                        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
                        errorBorderColor: AppColors.error,
                        borderColor: Theme.of(context).dividerColor,
                        borderWidth: 1,
                        maxLines: 1,
                        maxLength: 20,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                        cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
                        secureText: false,
                        onChange: (value) {
                          habitName = value;
                        },
                        contentPadding: const EdgeInsets.only(
                          top: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TitleDividerWidget(
                        text: AppStrings.repeatDays.tr,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: SelectWeekDays(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        days: DayInWeek.getWeekDays(),
                        border: false,
                        boxDecoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor)),
                        onSelect: (values) {
                          repeatDays = values;
                        },
                      ),
                    ),
                    SizedBox(
                      height: context.height * 0.1,
                    ),
                    ButtonWidget(
                      width: 220,
                      height: 45,
                      borderRadius: 0,
                      borderWidth: 1.0,
                      borderColor: Theme.of(context).dividerColor,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPress: _submitHabitFrom,
                      child: Text(
                        AppStrings.submit.tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
