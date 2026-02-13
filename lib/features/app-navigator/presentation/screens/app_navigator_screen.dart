import 'package:flutter/material.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';
import '../widgets/navigation_bar_widget.dart';

class AppNavigatorScreen extends StatefulWidget {
  const AppNavigatorScreen({super.key});

  @override
  State<AppNavigatorScreen> createState() => _AppNavigatorScreenState();
}

class _AppNavigatorScreenState extends State<AppNavigatorScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    _checkIfUserAuthenticated();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _checkIfUserAuthenticated() async {
    final authProvider = Provider.of<IAuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
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
