import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MonthStatsItemWidget extends StatelessWidget {
  final String name;
  final int total;
  final int totalDone;

  const MonthStatsItemWidget({
    Key? key,
    required this.name,
    required this.total,
    required this.totalDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            LineAwesomeIcons.arrow_right,
            color: AppColors.fontSecondary,
            size: 18,
          ),
          const SizedBox(width: 10,),
          Text(name.substring(0, name.length - 5),
              style: TextStyle(fontSize: 18, color: AppColors.fontSecondary)),
          const Spacer(),
          Text("$totalDone/$total",
            style: TextStyle(fontSize: 18, color: AppColors.fontSecondary),
          ),
        ],
      ),
    );
  }
}
