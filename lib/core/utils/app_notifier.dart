import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppNotifier {
  static void showErrorDialog({required BuildContext context, required String message}) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(message, style: const TextStyle(color: Colors.black, fontSize: 16),),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.black, textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('Ok'),
                )
              ],
            ));
  }

  static void showToast({required String message, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity ?? ToastGravity.BOTTOM,
        backgroundColor: color ?? AppColors.snackbar);
  }

  static void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.snackbar.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.none,
      content: Text(message, style: AppTextStyles.snackbar,),
    ));
  }
}
