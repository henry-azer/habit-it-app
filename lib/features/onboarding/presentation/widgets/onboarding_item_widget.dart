import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_styles.dart';

class OnboardingItem extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const OnboardingItem(
      {super.key,
      required this.title,
      required this.image,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.onboardingSubtitle,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Image.asset(image),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.onboardingDescription,
          ),
        ],
      ),
    );
  }
}
