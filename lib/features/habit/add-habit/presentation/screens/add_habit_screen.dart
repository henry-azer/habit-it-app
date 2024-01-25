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
import '../../../../../../core/utils/app_text_styles.dart';
import '../../../../../../core/validation/validation_types.dart';
import '../../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../../core/widgets/day-picker/widgets/select_day.dart';
import '../../../../../../core/widgets/forms/text_field_widget.dart';
import '../../../../../../core/widgets/title/title_divider_widget.dart';
import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_localization_strings.dart';

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
          message: AppLocalizationHelper.translate(
              context, AppLocalizationKeys.habitNameRequired));
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
              title: AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.habitTitle),
              backButton: true,
              height: 125,
              onPressBack: () {
                Navigator.of(context).pop(false);
              },
              titleStyle: AppTextStyles.headerTitle,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TitleDividerWidget(
                        text: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.createNewHabit),
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
                        text: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.habitNameCap),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: TextFieldWidget(
                        enabled: true,
                        hintText: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.habitName),
                        hintTextStyle: AppTextStyles.signupNameTextFieldHint,
                        keyboardType: TextInputType.emailAddress,
                        validateType: ValidationTypes.signupName,
                        errorStyle: AppTextStyles.signupNameTextFieldError,
                        errorBorderColor: AppColors.error,
                        borderColor: AppColors.border,
                        borderWidth: 1,
                        maxLines: 1,
                        maxLength: 20,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.signupNameTextField,
                        cursorColor: AppColors.fontSecondary,
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
                        text: AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.repeatDays),
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
                            border: Border.all(color: AppColors.white)),
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
                      borderColor: AppColors.border,
                      backgroundColor: AppColors.secondary,
                      onPress: _submitHabitFrom,
                      child: Text(
                        AppLocalizationHelper.translate(
                            context, AppLocalizationKeys.submit),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.signupSuccessButton,
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
