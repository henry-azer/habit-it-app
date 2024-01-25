import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppNotifier {
  static void showErrorDialog(
      {required BuildContext context, required String message}) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                message,
                style: TextStyle(color: AppColors.black, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.black,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: AppColors.black, fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.black,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: onClickYes,
              child: const Text("Yes"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.black,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: AppColors.black, fontSize: 16),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                descriptionMessage,
                style: TextStyle(color: AppColors.black, fontSize: 14),
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
                foregroundColor: AppColors.black,
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
                foregroundColor: AppColors.black,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(color: AppColors.black, fontSize: 16),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                descriptionMessage,
                style: TextStyle(color: AppColors.black, fontSize: 14),
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
                foregroundColor: AppColors.black,
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
                foregroundColor: AppColors.black,
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

  static void showToast(
      {required String message, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity ?? ToastGravity.BOTTOM,
        backgroundColor: color ?? AppColors.snackbar);
  }

  static void showSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.snackbar.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.none,
      content: Text(
        message,
        style: AppTextStyles.snackbar,
      ),
    ));
  }
}
