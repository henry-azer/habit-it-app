import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HabitItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressAction;
  final VoidCallback onPressRemove;
  final Color? textColor;
  final bool isDone;

  const HabitItemWidget({
    Key? key,
    required this.title,
    required this.onPressAction,
    required this.onPressRemove,
    required this.isDone,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.grey.withOpacity(0.09),
            ),
            child: Icon(
              LineAwesomeIcons.arrow_right,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 20),
          Text(title.substring(0, title.length - 5), style: AppTextStyles.habitNameText),
          const Expanded(child: SizedBox()),
          InkWell(
            onTap: onPressAction,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.grey.withOpacity(0.09),
              ),
              child: Icon(isDone ? Icons.check : Icons.close,
                  size: 18.0,
                  color: isDone ? AppColors.green : AppColors.red),
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: onPressRemove,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.grey.withOpacity(0.09),
              ),
              child: Icon(Icons.delete_outline, size: 18.0, color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
