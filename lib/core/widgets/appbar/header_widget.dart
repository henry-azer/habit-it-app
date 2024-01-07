import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../utils/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool backButton;
  final double height;
  final double paddingLeft;
  final TextStyle titleStyle;
  final VoidCallback? onPressBack;

  const HeaderWidget(
      {super.key,
      this.backButton = false,
      required this.title,
      required this.height,
      this.paddingLeft = 0.08,
      required this.titleStyle,
      this.onPressBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
        if (backButton) ...{
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: context.height * 0.078,
                      left: context.width * paddingLeft),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: onPressBack,
                    icon: const Icon(LineAwesomeIcons.angle_left),
                  ),
                ),
              ],
            ),
          ),
        },
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: context.height * 0.09),
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
