import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:habit_it/features/signin/biometric-signin/screens/signin_biometric_screen.dart';
import 'package:habit_it/features/signin/pin-signin/screens/signin_pin_screen.dart';

import '../../config/routes/app_routes.dart';
import '../../features/calendar-tasker/screens/calendar_tasker_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../utils/app_colors.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  NavigationBarWidgetState createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  final List<String> routes = [
    Routes.appHome,
    Routes.appCalendarTasker,
    Routes.signinPIN,
    Routes.signinBiometric
  ];
  final PageController _pageController = PageController();
  final double _selectedItemSize = 28.0;
  final double _defaultItemSize = 24.0;
  final double _navigationHeight = 42;
  int _selectedItemPosition = 0;

  @override
  void initState() {
    super.initState();
  }

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
            children: const [
              HomeScreen(),
              CalendarTaskerScreen(),
              SigninPINScreen(),
              SigninBiometricScreen()
            ],
          ),
        ),
        SnakeNavigationBar.color(
          height: _navigationHeight,
          backgroundColor: AppColors.black,
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.rectangle,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.grey,
          snakeViewColor: AppColors.primary.withOpacity(0.93),
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
                Icons.track_changes_sharp,
                size: _selectedItemPosition == 1
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.today_outlined,
                size: _selectedItemPosition == 2
                    ? _selectedItemSize
                    : _defaultItemSize,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_sharp,
                size: _selectedItemPosition == 3
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
