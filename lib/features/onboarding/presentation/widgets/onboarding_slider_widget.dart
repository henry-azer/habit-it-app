import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/features/onboarding/presentation/widgets/page_offset_provider_widget.dart';
import 'package:provider/provider.dart';

import 'background_widget.dart';
import 'background_body_widget.dart';
import 'background_controller_widget.dart';
import 'background_final_button_widget.dart';
import '../../../../core/widgets/appbar/cupertino_app_bar_widget.dart';

class OnBoardingSlider extends StatefulWidget {
  final int totalPage;

  final Color headerBackgroundColor;

  final List<Widget> background;

  final double speed;

  final Color? pageBackgroundColor;

  final Gradient? pageBackgroundGradient;

  final Function? onFinish;

  final Widget? trailing;

  final Widget? skipTextButton;

  final List<Widget> pageBodies;

  final Function? trailingFunction;

  final FinishButtonStyle? finishButtonStyle;

  final String? finishButtonText;

  final TextStyle finishButtonTextStyle;

  final Color? controllerColor;

  final bool addButton;

  final bool centerBackground;

  final bool addController;

  final double imageVerticalOffset;

  final double imageHorizontalOffset;

  final Widget? leading;

  final Widget? middle;

  final bool hasFloatingButton;

  final bool hasSkip;

  final Icon skipIcon;

  final bool indicatorAbove;

  final double indicatorPosition;

  final Function? skipFunctionOverride;

  const OnBoardingSlider({
    super.key,
    required this.totalPage,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    required this.pageBodies,
    this.onFinish,
    this.trailingFunction,
    this.trailing,
    this.skipTextButton,
    this.pageBackgroundColor,
    this.pageBackgroundGradient,
    this.finishButtonStyle,
    this.finishButtonText,
    this.controllerColor,
    this.addController = true,
    this.centerBackground = false,
    this.addButton = true,
    this.imageVerticalOffset = 0,
    this.imageHorizontalOffset = 0,
    this.leading,
    this.middle,
    this.hasFloatingButton = true,
    this.hasSkip = true,
    this.finishButtonTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
    ),
    this.skipIcon = const Icon(
      Icons.arrow_forward,
      color: Colors.black,
    ),
    this.indicatorAbove = false,
    this.indicatorPosition = 90,
    this.skipFunctionOverride,
  });

  @override
  OnBoardingSliderState createState() => OnBoardingSliderState();
}

class OnBoardingSliderState extends State<OnBoardingSlider> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        backgroundColor: widget.pageBackgroundColor,
        body: CupertinoPageScaffold(
          navigationBar: CupertinoAppBar(
            leading: widget.leading,
            middle: widget.middle,
            trailing: widget.trailing,
            headerBackgroundColor: widget.headerBackgroundColor,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: widget.pageBackgroundGradient,
              color: widget.pageBackgroundColor,
            ),
            child: SafeArea(
              child: Background(
                centerBackground: widget.centerBackground,
                imageHorizontalOffset: widget.imageHorizontalOffset,
                imageVerticalOffset: widget.imageVerticalOffset,
                background: widget.background,
                speed: widget.speed,
                totalPage: widget.totalPage,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BackgroundBody(
                          controller: _pageController,
                          function: slide,
                          totalPage: widget.totalPage,
                          bodies: widget.pageBodies,
                        ),
                      ),
                      widget.addController
                          ? BackgroundController(
                              hasFloatingButton: widget.hasFloatingButton,
                              indicatorPosition: widget.indicatorPosition,
                              indicatorAbove: widget.indicatorAbove,
                              currentPage: _currentPage,
                              totalPage: widget.totalPage,
                              controllerColor: widget.controllerColor,
                            )
                          : const SizedBox.shrink(),
                      BackgroundFinalButton(
                        buttonTextStyle: widget.finishButtonTextStyle,
                        skipIcon: widget.skipIcon,
                        addButton: widget.addButton,
                        currentPage: _currentPage,
                        pageController: _pageController,
                        totalPage: widget.totalPage,
                        onPageFinish: widget.onFinish,
                        finishButtonStyle: widget.finishButtonStyle,
                        buttonText: widget.finishButtonText,
                        hasSkip: widget.hasSkip,
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void slide(int page) {
    setState(() {
      _currentPage = page;
    });
  }
}
