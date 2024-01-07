import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';

class HabitStatsItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double containerWidth;
  final double containerHeight;
  final String imageAssetPath;
  final double imageWidth;
  final String description;
  final TextStyle descriptionStyle;

  const HabitStatsItemWidget({
    Key? key,
    required this.onTap,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageAssetPath,
    required this.imageWidth,
    required this.description,
    required this.descriptionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: containerWidth,
        height: containerHeight,
        color: AppColors.accent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAssetPath,
              width: imageWidth,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              description,
              style: descriptionStyle,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
