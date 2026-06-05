import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/datasources/user/user_local_datasource.dart';
import '../../../data/entities/user.dart';
import '../../../core/di/injection.dart';

/// Hosts the three bottom-nav branches and manages app-lifecycle de-auth.
///
/// Replaces the legacy `AppNavigatorScreen` + `NavigationBarWidget`. Uses
/// `StatefulNavigationShell` (the GoRouter primitive built for
/// `StatefulShellRoute.indexedStack`).
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  late final UserLocalDataSource _userDataSource;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userDataSource = getIt<UserLocalDataSource>();
    _checkAuthOnStart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _deAuthOnBackground();
    }
  }

  Future<void> _checkAuthOnStart() async {
    final User user = await _userDataSource.getUser();
    if (!user.isAuthenticated && mounted) {
      // Behavioral parity with legacy: redirect to PIN or biometric signin.
      final target = user.isBiometricAuthenticated ? '/signin/biometric' : '/signin/pin';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(target);
      });
    }
  }

  Future<void> _deAuthOnBackground() async {
    final User user = await _userDataSource.getUser();
    user.isAuthenticated = false;
    await _userDataSource.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        backgroundColor: context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
        selectedItemColor: AppColors.accentDefault,
        unselectedItemColor: context.colors.onSurfaceVariant,
        iconSize: AppSpacing.xl,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) => widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clipboardList),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartPie),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
