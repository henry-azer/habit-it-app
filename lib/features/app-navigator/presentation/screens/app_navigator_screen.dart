import 'package:flutter/material.dart';

import '../../../../core/widgets/navigation_bar_widget.dart';

class AppNavigatorScreen extends StatefulWidget {
  const AppNavigatorScreen({Key? key}) : super(key: key);

  @override
  State<AppNavigatorScreen> createState() => _AppNavigatorScreenState();
}

class _AppNavigatorScreenState extends State<AppNavigatorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Scaffold(
        bottomNavigationBar: NavigationBarWidget(),
      ),
    );
  }
}
