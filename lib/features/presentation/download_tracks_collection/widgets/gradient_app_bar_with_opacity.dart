import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';

class GradientAppBarWithOpacity extends StatelessWidget {
  const GradientAppBarWithOpacity.visible(
      {super.key,
      this.title = '',
      required this.firstColor,
      required this.secondaryColor,
      this.opacity = 0,
      this.height,
      this.iconSize = 35})
      : isAppBarVisible = true;

  const GradientAppBarWithOpacity.invisible({super.key, this.height, this.iconSize = 35})
      : isAppBarVisible = false,
        opacity = 0,
        title = '',
        firstColor = null,
        secondaryColor = null;

  final bool isAppBarVisible;
  final String title;
  final Color? firstColor;
  final Color? secondaryColor;
  final double opacity;
  final double? height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55 + MediaQuery.of(context).viewPadding.top,
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              if (isAppBarVisible) {
                return Opacity(
                  opacity: opacity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      firstColor ?? Colors.transparent,
                      getIntermediateColor(firstColor ?? Colors.transparent, secondaryColor ?? Colors.transparent, 0.5)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  ),
                );
              }
              return Container();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: Row(
              children: [
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      AutoRouter.of(context).pop();
                    },
                    icon: SvgPicture.asset(
                      'resources/images/svg/back_icon.svg',
                      height: iconSize,
                      width: iconSize,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Opacity(
                    opacity: opacity,
                    child: Builder(builder: (context) {
                      return Center(child: Text(title, style: Theme.of(context).textTheme.titleSmall));
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
