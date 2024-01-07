import 'package:flutter/material.dart';
 import 'package:flutter/rendering.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:habit_it/features/habit/stats/stats/presentation/screens/habit_stats_screen.dart';
import 'package:habit_it/features/profile/presentation/screens/profile_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../habit/habit/presentation/screens/habit_screen.dart';
import '../../../../core/utils/app_colors.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  NavigationBarWidgetState createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  final PageController _pageController = PageController();
  final double _selectedItemSize = 26.0;
  final double _defaultItemSize = 22.0;
  final double _navigationHeight = 42;
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedItemPosition = index;
              });
            },
            children: const [HabitScreen(), HabitStatsScreen(), ProfileScreen()],
          ),
        ),
        SnakeNavigationBar.color(
          height: _navigationHeight,
          backgroundColor: AppColors.black,
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.rectangle,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.grey,
          snakeViewColor: AppColors.accent,
          currentIndex: _selectedItemPosition,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.clipboard_list,
                size: _selectedItemPosition == 0
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.pie_chart,
                size: _selectedItemPosition == 1
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineAwesomeIcons.user,
                size: _selectedItemPosition == 2
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
