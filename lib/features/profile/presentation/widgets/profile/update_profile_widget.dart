import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/core/widgets/buttons/button_widget.dart';
import 'package:habit_it/core/widgets/forms/text_field_widget.dart';
import 'package:habit_it/data/enums/gender.dart';
import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_localization_strings.dart';
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
    final genderTextController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Divider(
            color: AppColors.white.withOpacity(0.7),
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
                    hintText: AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.username),
                    hintTextStyle: AppTextStyles.signupNameTextFieldHint,
                    keyboardType: TextInputType.emailAddress,
                    validateType: ValidationTypes.signupName,
                    errorStyle: AppTextStyles.signupNameTextFieldError,
                    errorBorderColor: AppColors.error,
                    borderColor: AppColors.border,
                    borderWidth: 1,
                    maxLines: 1,
                    maxLength: 16,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.signupNameTextField,
                    cursorColor: AppColors.fontSecondary,
                    secureText: false,
                    onSave: (value) {
                      updatedUser.username = value;
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
                    selectedStyle: AppTextStyles.signupGenderSelectedFieldItem,
                    hintStyle: AppTextStyles.signupGenderFieldHint,
                    hintText: AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.gender),
                    items: genders,
                    borderRadius: BorderRadius.zero,
                    errorStyle: AppTextStyles.signupGenderFieldError,
                    onChanged: (value) {
                      genderTextController.text = value;
                      updatedUser.gender = value;
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
                backgroundColor: AppColors.secondary,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderWidth: 0.7,
                borderColor: AppColors.border,
                child: Text(
                  AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.update),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.profileUpdateButtonText,
                ),
              ),
              ButtonWidget(
                onPress: onCancel,
                backgroundColor: Colors.transparent,
                width: 120,
                height: 40,
                borderRadius: 0,
                borderColor: AppColors.border,
                borderWidth: 0.7,
                child: Text(
                  AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.cancel),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.profileCancelButtonText,
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
