import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:habit_it/features/profile/presentation/screens/profile_screen.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../../../core/utils/app_colors.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  NavigationBarWidgetState createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  final PageController _pageController = PageController();
  final double _selectedItemSize = 28.0;
  final double _defaultItemSize = 24.0;
  final double _navigationHeight = 42;
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedItemPosition = index;
              });
            },
            children: const [HomeScreen(), ProfileScreen()],
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
                Icons.home_sharp,
                size: _selectedItemPosition == 0
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_sharp,
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
