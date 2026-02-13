import 'package:flutter/material.dart';
import 'package:habit_it/features/habit/stats/stats/presentation/screens/habit_stats_screen.dart';
import 'package:habit_it/features/profile/presentation/screens/profile_screen.dart';

import '../../../habit/habit/presentation/screens/habit_screen.dart';
import '../../../../core/utils/app_colors.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  NavigationBarWidgetState createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  final PageController _pageController = PageController();
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        BottomNavigationBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          selectedItemColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          unselectedItemColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          currentIndex: _selectedItemPosition,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }
}
