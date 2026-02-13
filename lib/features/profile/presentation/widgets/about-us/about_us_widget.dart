import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_strings.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../core/widgets/buttons/icon_text_button_widget.dart';

class AboutUsWidget extends StatelessWidget {
  final Function() onBackPressed;

  const AboutUsWidget({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500) ?? const TextStyle();
    final buttonBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: isDark
                  ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconTextButton(
                height: 40,
                width: 150,
                icon: Icons.link,
                text: 'linkedin_name'.tr,
                onPressed: () {
                  launchUrl(Uri.parse('linkedin_link'.tr));
                },
                textStyle: buttonTextStyle,
                backgroundColor: buttonBg,
                iconColor: AppColors.linkedin,
              ),
              IconTextButton(
                height: 40,
                width: 150,
                icon: Icons.code,
                text: 'github_name'.tr,
                onPressed: () {
                  launchUrl(Uri.parse('github_link'.tr));
                },
                textStyle: buttonTextStyle,
                backgroundColor: buttonBg,
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
                  icon: Icons.chat,
                  text: 'whatsapp_name'.tr,
                  onPressed: () {
                    launchUrl(Uri.parse('whatsapp_link'.tr));
                  },
                  textStyle: buttonTextStyle,
                  backgroundColor: buttonBg,
                  iconColor: AppColors.whatsapp,
                ),
                IconTextButton(
                  height: 40,
                  width: 150,
                  icon: Icons.facebook,
                  text: 'facebook_name'.tr,
                  onPressed: () {
                    launchUrl(Uri.parse('facebook_link'.tr));
                  },
                  textStyle: buttonTextStyle,
                  backgroundColor: buttonBg,
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
            text: 'mail_name'.tr,
            onPressed: () {
              launchUrl(Uri.parse('mail_link'.tr));
            },
            textStyle: buttonTextStyle,
            backgroundColor: buttonBg,
            iconColor: AppColors.outlook,
          ),
          const SizedBox(height: 50),
          ButtonWidget(
            onPress: onBackPressed,
            backgroundColor: Colors.transparent,
            width: 120,
            height: 40,
            borderRadius: 0,
            borderColor: Theme.of(context).dividerColor,
            borderWidth: 0.7,
            child: Text(
              AppStrings.back.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
