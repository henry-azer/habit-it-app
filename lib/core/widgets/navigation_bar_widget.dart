import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../config/routes/app_routes.dart';
import '../utils/app_colors.dart';

class NavigationBarWidget extends StatefulWidget {
  final String? path;
  const NavigationBarWidget({Key? key, this.path}) : super(key: key);

  @override
  NavigationBarWidgetState createState() => NavigationBarWidgetState();
}

class NavigationBarWidgetState extends State<NavigationBarWidget> {
  // TODO : change routes to whatever you want
  List<String> routes = [Routes.appHome];
  late int _selectedItemPosition = routes.indexOf(widget.path!);
  final double _selectedItemSize = 28.0;
  final double _defaultItemSize = 24.0;
  final double _navigationHeight = 42;

  @override
  Widget build(BuildContext context) {

    return SnakeNavigationBar.color(
      height: _navigationHeight,
      backgroundColor: AppColors.black,
      padding: const EdgeInsets.only(bottom: 30, left: 60, right: 60),

      behaviour: SnakeBarBehaviour.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),

      snakeShape: SnakeShape.rectangle,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.grey,
      snakeViewColor: AppColors.primary.withOpacity(0.9),

      currentIndex: _selectedItemPosition,
      onTap: (index) => {
        setState(() => _selectedItemPosition = index),
        if(widget.path != routes.elementAt(index)) Navigator.pushReplacementNamed(context, routes.elementAt(index)),
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,
            size: _selectedItemPosition == 0 ? _selectedItemSize : _defaultItemSize),
            label: 'home'),
        // TODO : change BottomNavigationBarItems route to whatever you want
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.search_outlined,
        //     size: _selectedItemPosition == 1 ? _selectedItemSize : _defaultItemSize),
        //     label: 'search'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.star_border_sharp,
        //     size: _selectedItemPosition == 2 ? _selectedItemSize : _defaultItemSize),
        //     label: 'rated'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.account_circle_outlined,
        //     size: _selectedItemPosition == 3 ? _selectedItemSize : _defaultItemSize),
        //     label: 'profile'),
      ],
    );
  }
}
