import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Color headerBackgroundColor;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  const CupertinoAppBar({
    super.key,
    required this.headerBackgroundColor,
    this.leading,
    this.middle,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      leading: leading,
      middle: middle,
      trailing: trailing,
      border: const Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      backgroundColor: headerBackgroundColor,
    );
  }
}
