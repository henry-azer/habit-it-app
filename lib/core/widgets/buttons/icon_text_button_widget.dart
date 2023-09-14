import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';

import '../../utils/app_text_styles.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.iconTextButton,
            ),
            Icon(icon, color: AppColors.fontSecondary),
          ],
        ),
      ),
    );
  }
}
