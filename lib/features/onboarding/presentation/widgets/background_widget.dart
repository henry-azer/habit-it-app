import 'package:flutter/material.dart';

import 'background_image_widget.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int totalPage;
  final List<Widget> background;
  final double speed;
  final double imageVerticalOffset;
  final double imageHorizontalOffset;
  final bool centerBackground;

  const Background({
    super.key,
    required this.imageVerticalOffset,
    required this.child,
    required this.centerBackground,
    required this.totalPage,
    required this.background,
    required this.speed,
    required this.imageHorizontalOffset,
  });

  @override
  Widget build(BuildContext context) {
    assert(background.length == totalPage);
    return Stack(
      children: [
        for (int i = 0; i < totalPage; i++)
          BackgroundImage(
              centerBackground: centerBackground,
              imageHorizontalOffset: imageHorizontalOffset,
              imageVerticalOffset: imageVerticalOffset,
              id: totalPage - i,
              speed: speed,
              background: background[totalPage - i - 1]),
        child,
      ],
    );
  }
}
