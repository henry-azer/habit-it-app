import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/core/widgets/buttons/button_widget.dart';
import 'package:habit_it/core/widgets/forms/text_field_widget.dart';
import 'package:habit_it/data/enums/gender.dart';
import '../../../../../core/validation/validation_types.dart';
import '../../../../../core/widgets/dropdown/custom_dropdown.dart';
import '../../../../../data/entities/user.dart';

class UpdateProfileWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final User updatedUser;
  final Function() onCancel;
  final Function() onSubmit;

  const UpdateProfileWidget({
    super.key,
    required this.updatedUser,
    required this.onCancel,
    required this.onSubmit,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final genderTextController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Divider(
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                : AppColors.lightTextSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 35),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFieldWidget(
                    enabled: true,
                    hintText: AppStrings.username.tr,
                    hintTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.text,
                    validateType: ValidationTypes.signupName,
                    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    errorBorderColor: AppColors.error,
                    borderColor: Theme.of(context).dividerColor,
                    borderWidth: 1,
                    maxLines: 1,
                    maxLength: 16,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                    cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
                    secureText: false,
                    onSave: (value) {
                      // User is now immutable - handle via provider
                    },
                    contentPadding: const EdgeInsets.only(
                      top: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: CustomDropdown(
                    fillColor: Colors.transparent,
                    selectedStyle: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor) ?? const TextStyle(),
                    hintText: AppStrings.gender.tr,
                    items: genders,
                    borderRadius: BorderRadius.zero,
                    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error) ?? const TextStyle(),
                    onChanged: (value) {
                      genderTextController.text = value;
                    },
                    controller: genderTextController,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.height * 0.12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                onPress: onSubmit,
                backgroundColor: Theme.of(context).colorScheme.primary,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderWidth: 0.7,
                borderColor: Theme.of(context).dividerColor,
                child: Text(
                  AppStrings.update.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              ButtonWidget(
                onPress: onCancel,
                backgroundColor: Colors.transparent,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderColor: Theme.of(context).dividerColor,
                borderWidth: 0.7,
                child: Text(
                  AppStrings.cancel.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
