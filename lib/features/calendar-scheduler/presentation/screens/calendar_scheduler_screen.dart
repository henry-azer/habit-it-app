import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_styles.dart';

class CalendarSchedulerScreen extends StatefulWidget {
  const CalendarSchedulerScreen({Key? key}) : super(key: key);

  @override
  State<CalendarSchedulerScreen> createState() =>
      _CalendarSchedulerScreenState();
}

class _CalendarSchedulerScreenState extends State<CalendarSchedulerScreen> {
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
          "Calender Scheduler Screen",
          style: AppTextStyles.homeText,
        ),
      )),
    );
  }
}
