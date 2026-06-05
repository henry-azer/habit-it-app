import 'package:flutter/widgets.dart';

import 'app_lock_service.dart';

/// AUTH-005 — `WidgetsBindingObserver` that records pause/resume and lets
/// `AppLockService` decide whether the auto-lock threshold has elapsed.
///
/// Lives at the root of the widget tree (mounted by `HabitItApp`); replaces
/// `AppShell._deAuthOnBackground` for the AUTH-005 flow. The legacy
/// `_deAuthOnBackground` remains in `AppShell` to keep un-upgraded installs
/// working with the legacy signin path (see PROGRESS.md AQ-4).
class AppLockLifecycleObserver extends StatefulWidget {
  const AppLockLifecycleObserver({
    super.key,
    required this.service,
    required this.child,
  });

  final AppLockService service;
  final Widget child;

  @override
  State<AppLockLifecycleObserver> createState() =>
      _AppLockLifecycleObserverState();
}

class _AppLockLifecycleObserverState extends State<AppLockLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        widget.service.recordPaused(DateTime.now());
        break;
      case AppLifecycleState.resumed:
        widget.service.evaluateResume(DateTime.now());
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
