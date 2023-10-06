import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/validation/validation_types.dart';
import '../../../../../core/widgets/forms/text_field_widget.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(String) onAddHabit;

  const AddHabitDialog({Key? key, required this.onAddHabit}) : super(key: key);

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  String habitName = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      child: CupertinoAlertDialog(
        title: Text(
          "Add Habit",
          style: AppTextStyles.alertDialogTitle,
        ),
        content: Padding(
          padding: const EdgeInsets.only(
              left: 00.0, right: 10.0, top: 25.0, bottom: 4.0),
          child: Material(
            color: Colors.transparent,
            child: TextFieldWidget(
              enabled: true,
              hintText: 'Habit',
              hintTextStyle: AppTextStyles.signupNameTextFieldHint,
              keyboardType: TextInputType.emailAddress,
              validateType: ValidationTypes.signupName,
              errorStyle: AppTextStyles.signupNameTextFieldError,
              errorBorderColor: AppColors.error,
              borderColor: AppColors.borderSecondary,
              borderWidth: 1,
              maxLines: 1,
              maxLength: 16,
              textAlign: TextAlign.center,
              style: AppTextStyles.alertDialogActionTextField,
              cursorColor: AppColors.fontSecondary,
              counterStyle: TextStyle(color: AppColors.black),
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
              foregroundColor: AppColors.black,
              textStyle: AppTextStyles.alertDialogActionButton,
            ),
            onPressed: () async {
              if (habitName.isNotEmpty) {
                widget.onAddHabit(habitName);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Submit"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.black,
              textStyle: AppTextStyles.alertDialogActionButton,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
