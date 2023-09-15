import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          "Profile Screen",
          style: AppTextStyles.homeText,
        ),
      )),
    );
  }
}
