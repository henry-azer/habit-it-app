import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';

import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/validation/validation_types.dart';
import '../../../../../../core/widgets/forms/text_field_widget.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(String) onAddHabit;
  final String title;
  final String hintText;

  const AddHabitDialog(
      {Key? key,
      required this.onAddHabit,
      required this.title,
      required this.hintText})
      : super(key: key);

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  String habitName = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: Theme.of(context).scaffoldBackgroundColor,
        scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: CupertinoAlertDialog(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 25.0, bottom: 4.0),
          child: Material(
            color: Colors.transparent,
            child: TextFieldWidget(
              enabled: true,
              hintText: widget.hintText,
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
              counterStyle: Theme.of(context).textTheme.bodySmall,
              secureText: false,
              onChange: (value) {
                habitName = value;
              },
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (habitName.isNotEmpty) {
                widget.onAddHabit(habitName);
              }
            },
            child: Text(AppStrings.submit.tr),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppStrings.cancel.tr),
          ),
        ],
      ),
    );
  }
}
