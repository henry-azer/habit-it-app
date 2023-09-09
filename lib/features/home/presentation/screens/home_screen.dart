import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/widgets/navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
              child: Text("Hello Developer!", style: AppTextStyle.homeText,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 35.0),
                child: GestureDetector(
                  onTap: () {
                    // TODO : change route to whatever you want
                    Navigator.pushReplacementNamed(context, Routes.appHome);
                  },
                  child: Image.asset(
                    ImgAssets.user,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
          extendBody: true,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: NavigationBarWidget(path: ModalRoute.of(context)?.settings.name),
          body: Center(child: Text("Start Coding!", style: AppTextStyle.homeText,),
          )),
    );
  }
}
