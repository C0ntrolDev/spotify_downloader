import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';

abstract class OrientatedNavigationBarItemTile extends StatefulWidget {
  final OrientatedNavigationBarItem item;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final void Function() onTap;
  final bool isSelected;

  const OrientatedNavigationBarItemTile(
      {super.key,
      required this.iconSize,
      required this.labelFontSize,
      required this.selectingSize,
      required this.selectedItemColor,
      required this.unselectedItemColor,
      required this.selectingItemColor,
      required this.onTap,
      required this.isSelected,
      required this.item,
      required this.animationDuration,
      required this.animationCurve});
}

abstract class OrientatedNavigationBarItemTileState<T extends OrientatedNavigationBarItemTile> extends State<T>
    with TickerProviderStateMixin {
  late final AnimationController _colorAnimationController;
  late final AnimationController _sizeAnimationController;

  Animation<double>? sizeAnimation;
  Animation<Color?>? colorAnimation;

  bool isTapping = false;

  Color get initialColor => widget.isSelected ? widget.selectedItemColor : widget.unselectedItemColor;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _sizeAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _updateAnimations();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      _updateAnimations();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateAnimations() {
    final beginColor = colorAnimation?.value ?? initialColor;
    final endColor = isTapping
        ? widget.selectingItemColor
        : widget.isSelected
            ? widget.selectedItemColor
            : widget.unselectedItemColor;

    final double beginSize = sizeAnimation?.value ?? 1;
    final double endSize = isTapping ? widget.selectingSize : 1;

    if (beginColor != endColor || colorAnimation == null) {
      _colorAnimationController.reset();
      colorAnimation = ColorTween(begin: beginColor, end: endColor)
          .animate(CurvedAnimation(parent: _colorAnimationController, curve: widget.animationCurve));
      _colorAnimationController.forward();
    }

    if (beginSize != endSize || sizeAnimation == null) {
      _sizeAnimationController.reset();
      sizeAnimation = Tween<double>(begin: beginSize, end: endSize)
          .animate(CurvedAnimation(parent: _sizeAnimationController, curve: widget.animationCurve));
      _sizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          isTapping = true;
          _updateAnimations();
        },
        onTapUp: (details) {
          isTapping = false;
          widget.onTap();
          _updateAnimations();
        },
        onTapCancel: () {
          isTapping = false;
          _updateAnimations();
        },
        child: AnimatedBuilder(
            animation: sizeAnimation!,
            builder: (context, _) {
              return AnimatedBuilder(
                  animation: colorAnimation!,
                  builder: (context, _) {
                    if (sizeAnimation == null || colorAnimation == null || colorAnimation!.value == null) {
                      return Container();
                    }
                    return buildWithAnimations(sizeAnimation!.value, colorAnimation!.value!);
                  });
            }));
  }

  Widget buildWithAnimations(double sizeAnimation, Color colorAnimation);
}
