// File preserved as a no-op shim. The legacy snake-navigation widget was
// replaced by `AppShell` (`features/shell/screens/app_shell.dart`) when
// FND-005 (GoRouter) shipped. This file is kept so old imports do not
// trigger source-tree noise but the widget itself is no longer used.
//
// Remove this file once `lib/features/app-navigator/` is deleted in the
// post-Foundation cleanup pass.
import 'package:flutter/material.dart';

@Deprecated('Use AppShell (features/shell/screens/app_shell.dart) — replaced in FND-005')
class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
