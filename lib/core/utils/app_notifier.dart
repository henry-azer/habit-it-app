import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';

import 'app_colors.dart';

class AppNotifier {
  static void showErrorDialog(
      {required BuildContext context, required String message}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      foregroundColor: textColor,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('Ok'),
                )
              ],
            ));
  }

  static void showAlertDialog(
      {required BuildContext context,
      required String message,
      required Function() onClickYes}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: onClickYes,
              child: const Text("Yes"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteActionDialog({
    required BuildContext context,
    required String message,
    required String descriptionMessage,
    required Function() onClickYes,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                descriptionMessage,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                AppImageAssets.remove,
                width: 160,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onClickYes,
              child: const Text("Yes"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  static void showMoveHabitsActionDialog({
    required BuildContext context,
    required String message,
    required String descriptionMessage,
    required Function() onClickYes,
    required Function() onClickNo,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                descriptionMessage,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                AppImageAssets.addHabit,
                width: 160,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onClickYes,
              child: const Text("Yes"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onClickNo,
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  static void showSnackBar(
      {required BuildContext context, required String message}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isDark
          ? AppColors.darkCardBackground.withValues(alpha: 0.9)
          : AppColors.lightTextPrimary.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.none,
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ));
  }
}
