import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
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
    required this.height, required this.textStyle,
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
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Icon(icon, color: AppColors.fontSecondary),
          ],
        ),
      ),
    );
  }
}
