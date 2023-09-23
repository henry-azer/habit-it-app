import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../core/widgets/buttons/icon_text_button_widget.dart';

class AboutUsWidget extends StatelessWidget {
  final Function() onBackPressed;

  const AboutUsWidget({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconTextButton(
                height: 40,
                width: 150,
                icon: LineAwesomeIcons.linkedin_in,
                text: AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.linkedinName),
                onPressed: () {
                  launch(AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.linkedinLink));
                },
                textStyle: AppTextStyles.profileIconTextButton,
                backgroundColor: AppColors.secondary,
                iconColor: AppColors.linkedin,
              ),
              IconTextButton(
                height: 40,
                width: 150,
                icon: LineAwesomeIcons.github,
                text: AppLocalizationHelper.translate(
                    context, AppLocalizationKeys.githubName),
                onPressed: () {
                  launch(AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.githubLink));
                },
                textStyle: AppTextStyles.profileIconTextButton,
                backgroundColor: AppColors.secondary,
                iconColor: AppColors.github,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconTextButton(
                  height: 40,
                  width: 150,
                  icon: LineAwesomeIcons.what_s_app,
                  text: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.whatsappName),
                  onPressed: () {
                    launch(AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.whatsappLink));
                  },
                  textStyle: AppTextStyles.profileIconTextButton,
                  backgroundColor: AppColors.secondary,
                  iconColor: AppColors.whatsapp,
                ),
                IconTextButton(
                  height: 40,
                  width: 150,
                  icon: LineAwesomeIcons.facebook_f,
                  text: AppLocalizationHelper.translate(
                      context, AppLocalizationKeys.facebookName),
                  onPressed: () {
                    launch(AppLocalizationHelper.translate(
                        context, AppLocalizationKeys.facebookLink));
                  },
                  textStyle: AppTextStyles.profileIconTextButton,
                  backgroundColor: AppColors.secondary,
                  iconColor: AppColors.facebook,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          IconTextButton(
            height: 40,
            width: 150,
            icon: Icons.email_outlined,
            text: AppLocalizationHelper.translate(
                context, AppLocalizationKeys.mailName),
            onPressed: () {
              launch(AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.mailLink));
            },
            textStyle: AppTextStyles.profileIconTextButton,
            backgroundColor: AppColors.secondary,
            iconColor: AppColors.outlook,
          ),
          const SizedBox(height: 50),
          ButtonWidget(
            onPress: onBackPressed,
            backgroundColor: Colors.transparent,
            width: 120,
            height: 40,
            borderRadius: 0,
            borderColor: AppColors.border,
            borderWidth: 0.7,
            child: Text(
              AppLocalizationHelper.translate(
                  context, AppLocalizationKeys.back),
              textAlign: TextAlign.center,
              style: AppTextStyles.profileBackButtonText,
            ),
          ),
        ],
      ),
    );
  }
}
