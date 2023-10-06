import 'package:flutter/material.dart';

import 'floating_speed_dial_child.dart';

class FloatingSpeedDial extends StatefulWidget {
  const FloatingSpeedDial({
    Key? key,
    required this.child,
    required this.speedDialChildren,
    this.labelsStyle,
    this.labelsBackgroundColor,
    this.controller,
    this.closedForegroundColor,
    this.openForegroundColor,
    this.closedBackgroundColor,
    this.openBackgroundColor,
  }) : super(key: key);

  final Widget child;

  final List<FloatingSpeedDialChild> speedDialChildren;

  final TextStyle? labelsStyle;

  final Color? labelsBackgroundColor;

  final AnimationController? controller;

  final Color? closedForegroundColor;

  final Color? openForegroundColor;

  final Color? closedBackgroundColor;

  final Color? openBackgroundColor;

  @override
  State<StatefulWidget> createState() {
    return _SpeedDialState();
  }
}

class _SpeedDialState extends State<FloatingSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _foregroundColorAnimation;
  final List<Animation<double>> _speedDialChildAnimations =
      <Animation<double>>[];

  @override
  void initState() {
    _animationController = widget.controller ??
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _backgroundColorAnimation = ColorTween(
      begin: widget.closedBackgroundColor,
      end: widget.openBackgroundColor,
    ).animate(_animationController);

    _foregroundColorAnimation = ColorTween(
      begin: widget.closedForegroundColor,
      end: widget.openForegroundColor,
    ).animate(_animationController);

    final double fractionOfOneSpeedDialChild =
        1.0 / widget.speedDialChildren.length;
    for (int speedDialChildIndex = 0;
        speedDialChildIndex < widget.speedDialChildren.length;
        ++speedDialChildIndex) {
      final List<TweenSequenceItem<double>> tweenSequenceItems =
          <TweenSequenceItem<double>>[];

      final double firstWeight =
          fractionOfOneSpeedDialChild * speedDialChildIndex;
      if (firstWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.0),
          weight: firstWeight,
        ));
      }

      tweenSequenceItems.add(TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: fractionOfOneSpeedDialChild,
      ));

      final double lastWeight = fractionOfOneSpeedDialChild *
          (widget.speedDialChildren.length - 1 - speedDialChildIndex);
      if (lastWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
            tween: ConstantTween<double>(1.0), weight: lastWeight));
      }

      _speedDialChildAnimations.insert(
          0,
          TweenSequence<double>(tweenSequenceItems)
              .animate(_animationController));
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int speedDialChildAnimationIndex = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!_animationController.isDismissed)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: widget.speedDialChildren
                  .map<Widget>((FloatingSpeedDialChild floatingSpeedDialChild) {
                final Widget speedDialChildWidget = Opacity(
                  opacity:
                      _speedDialChildAnimations[speedDialChildAnimationIndex]
                          .value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (floatingSpeedDialChild.label != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Card(
                            elevation: 6.0,
                            color: widget.labelsBackgroundColor ?? Colors.white,
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () => _onTap(floatingSpeedDialChild),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  floatingSpeedDialChild.label!,
                                  style: widget.labelsStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ScaleTransition(
                        scale: _speedDialChildAnimations[
                            speedDialChildAnimationIndex],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: FloatingActionButton(
                            heroTag: speedDialChildAnimationIndex,
                            mini: true,
                            foregroundColor: floatingSpeedDialChild.foregroundColor,
                            backgroundColor: floatingSpeedDialChild.backgroundColor,
                            onPressed: () => _onTap(floatingSpeedDialChild),
                            child: floatingSpeedDialChild.child,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                speedDialChildAnimationIndex++;
                return speedDialChildWidget;
              }).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FloatingActionButton(
            foregroundColor: _foregroundColorAnimation.value,
            backgroundColor: _backgroundColorAnimation.value,
            onPressed: () {
              if (_animationController.isDismissed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
            child: widget.child,
          ),
        )
      ],
    );
  }

  void _onTap(FloatingSpeedDialChild floatingSpeedDialChild) {
    if (floatingSpeedDialChild.closeSpeedDialOnPressed) {
      _animationController.reverse();
    }
    floatingSpeedDialChild.onPressed.call();
  }
}
