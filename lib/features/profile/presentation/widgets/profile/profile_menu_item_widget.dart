import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuItemWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      hoverColor: AppColors.primary,
      highlightColor: AppColors.primary,
      focusColor: AppColors.primary,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.accent,
              ),
              child: Icon(icon, color: AppColors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: textColor ?? AppColors.fontPrimary),
              ),
            ),
            if (endIcon)
              SizedBox(
                width: 30,
                height: 30,
                child: Icon(LineAwesomeIcons.angle_right,
                    size: 18.0, color: AppColors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
