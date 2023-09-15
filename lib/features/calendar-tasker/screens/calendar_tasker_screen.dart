import 'package:flutter/material.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../widgets/calendar_app_bar_widget.dart';

class CalendarTaskerScreen extends StatefulWidget {
  const CalendarTaskerScreen({Key? key}) : super(key: key);

  @override
  State<CalendarTaskerScreen> createState() => _CalendarTaskerScreenState();
}

class _CalendarTaskerScreenState extends State<CalendarTaskerScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CalendarAppBar(
            locale: 'en',
            backButton: false,
            firstDate: DateTime.now(),
            lastDate: DateTime.now(),
            onDateChanged: onDateChanged,

            // colors
            white: Colors.white,
            black: Colors.black,
            accent: Colors.blue,

            // mark dotted
            events: List.generate(10,
                (index) => DateTime.now().subtract(Duration(days: index * 2)))),
        extendBody: true,
        resizeToAvoidBottomInset: true,
        // bottomNavigationBar:
        //     NavigationBarWidget(path: ModalRoute.of(context)?.settings.name),
        body: Center(
          child: _buildDayTasks(),
        ),
      ),
    );
  }

  Widget _buildDayTasks() {
    return Text(
      "Day Page - ${selectedDate.toLocal()}",
      style: AppTextStyles.homeText,
    );
  }
}
