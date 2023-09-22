import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback onPress;

  const ButtonWidget({
    super.key,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.onPress,
    required this.child,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}
