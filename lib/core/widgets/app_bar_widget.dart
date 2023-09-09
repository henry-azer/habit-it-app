import 'package:flutter/material.dart';

import '../../config/routes/app_routes.dart';
import '../utils/app_colors.dart';
import '../utils/assets_manager.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 65, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          GestureDetector(
            onTap: () {
              // TODO : change appHome route to whatever you want
              Navigator.pushReplacementNamed(context, Routes.appHome);
            },
            child: Image.asset(
              ImgAssets.user,
              width: 35,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
