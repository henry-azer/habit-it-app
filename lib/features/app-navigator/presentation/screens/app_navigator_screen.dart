// Legacy `AppNavigatorScreen` — kept as an empty shim. Replaced by
// `AppShell` (`features/shell/screens/app_shell.dart`) in FND-005.
//
// Remove this file once `lib/features/app-navigator/` is dropped in the
// post-Foundation cleanup pass.
import 'package:flutter/material.dart';

@Deprecated('Use AppShell — replaced in FND-005')
class AppNavigatorScreen extends StatelessWidget {
  const AppNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
