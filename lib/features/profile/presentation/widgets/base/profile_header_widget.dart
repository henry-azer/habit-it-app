import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String image;
  final String title;

  const ProfileHeaderWidget(
      {super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 75,
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(image: AssetImage(image))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Text(
                  title,
                  style: AppTextStyles.profileTitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
