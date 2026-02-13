import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isDark ? AppColors.darkSurface : AppColors.lightSecondary,
              ),
              child: Icon(icon, color: AppColors.darkTextPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: textColor),
              ),
            ),
            if (endIcon)
              SizedBox(
                width: 30,
                height: 30,
                child: Icon(Icons.chevron_right,
                    size: 18.0, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
