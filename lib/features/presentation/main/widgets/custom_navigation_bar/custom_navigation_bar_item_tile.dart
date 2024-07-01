import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_navigation_bar/custom_navigation_bar_item.dart';

class CustomNavigationBarItemTile extends StatefulWidget {
  final CustomNavigationBarItem item;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final void Function() onTap;
  final bool isSelected;

  const CustomNavigationBarItemTile(
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
      required this.animationDuration});

  @override
  State<CustomNavigationBarItemTile> createState() => _CustomNavigationBarItemTileState();
}


class _CustomNavigationBarItemTileState extends State<CustomNavigationBarItemTile> with TickerProviderStateMixin {
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
  void didUpdateWidget(covariant CustomNavigationBarItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _updateAnimations();
    }
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
      colorAnimation = ColorTween(begin: beginColor, end: endColor).animate(_colorAnimationController);
      _colorAnimationController.forward();
    }

    if (beginSize != endSize || sizeAnimation == null) {
      _sizeAnimationController.reset();
      sizeAnimation = Tween<double>(begin: beginSize, end: endSize).animate(_sizeAnimationController);
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
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              widget.isSelected ? widget.item.svgActiveIconPath : widget.item.svgIconPath,
                              width: widget.iconSize.width * sizeAnimation!.value,
                              height: widget.iconSize.height * sizeAnimation!.value,
                              colorFilter: ColorFilter.mode(colorAnimation!.value!, BlendMode.srcIn),
                            ),
                            Text(widget.item.label,
                                style: TextStyle(
                                    color: colorAnimation!.value, fontSize: widget.labelFontSize * sizeAnimation!.value))
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}

