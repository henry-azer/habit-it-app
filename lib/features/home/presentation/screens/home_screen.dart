import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          body: Center(
            child: Text(
              "Home Screen",
              style: AppTextStyles.homeText,
            ),
          )),
    );
  }
}
