import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';

class TapAnimatedContainer extends StatefulWidget {
  final void Function()? onTap;
  final Widget child;
  final Color tappingMaskColor;
  final double tappingScale;
  final Duration duration;
  final Curve curve;

  const TapAnimatedContainer(
      {super.key,
      required this.child,
      required this.tappingMaskColor,
      required this.tappingScale,
      this.duration = tappingAnimationDuration,
      this.curve = Curves.easeIn,
      this.onTap});

  @override
  State<TapAnimatedContainer> createState() => _TapAnimatedContainerState();
}

class _TapAnimatedContainerState extends State<TapAnimatedContainer> {
  bool isTapping = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      onTapDown: (details) {
        setState(() {
          isTapping = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isTapping = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapping = false;
        });
      },
      child: AnimatedScale(
        duration: widget.duration,
        curve: widget.curve,
        scale: isTapping ? widget.tappingScale : 1,
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
                child: AnimatedOpacity(
              duration: widget.duration,
              opacity: isTapping ? 1 : 0,
              child: Container(color: widget.tappingMaskColor),
            ))
          ],
        ),
      ),
    );
  }
}
