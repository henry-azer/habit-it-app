import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/core/widgets/buttons/button_widget.dart';
import 'package:habit_it/core/widgets/forms/dropdown_field_widget.dart';
import 'package:habit_it/core/widgets/forms/text_field_widget.dart';
import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/validation/validation_types.dart';
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
    required this.onSubmit, required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Divider(color: AppColors.white.withOpacity(0.7),),
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
                    hintText: 'Username',
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
                const SizedBox(height: 30,),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: DropdownFieldWidget<String>(
                    borderWidth: 1,
                    hintText: 'Gender',
                    items: AppConstants.genders,
                    borderColor: AppColors.border,
                    hintTextStyle: AppTextStyles.signupGenderFieldHint,
                    errorStyle: AppTextStyles.signupGenderFieldError,
                    errorBorderColor: AppColors.error,
                    itemTextStyle: AppTextStyles.signupGenderFieldItem,
                    selectedItemTextStyle:
                        AppTextStyles.signupGenderSelectedFieldItem,
                    validateType: ValidationTypes.signupGender,
                    onSave: (value) {
                      if (value != null) {
                        updatedUser.gender = value;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
            ],
          )
        ],
      ),
    );
  }
}
