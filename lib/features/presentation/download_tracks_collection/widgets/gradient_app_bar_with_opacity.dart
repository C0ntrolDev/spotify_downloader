import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/utils/util_methods.dart';

class GradientAppBarWithOpacity extends StatelessWidget {
  const GradientAppBarWithOpacity.visible(
      {super.key,
      this.title = '',
      required this.firstColor,
      required this.secondaryColor,
      this.opacity = 0,
      this.height = appBarHeight,
      this.iconSize = backIconSize})
      : isAppBarVisible = true;

  const GradientAppBarWithOpacity.invisible({super.key, this.height = appBarHeight, this.iconSize = backIconSize})
      : isAppBarVisible = false,
        opacity = 0,
        title = '',
        firstColor = Colors.transparent,
        secondaryColor = Colors.transparent;

  final bool isAppBarVisible;
  final String title;
  final Color firstColor;
  final Color secondaryColor;
  final double opacity;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + MediaQuery.of(context).viewPadding.top,
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              if (isAppBarVisible) {
                
                return Opacity(
                  opacity: normalize(opacity, 0, 0.5).clamp(0, 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      getIntermediateColor(firstColor, secondaryColor, 0.5),
                      getIntermediateColor(firstColor, secondaryColor, 0.7)
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Opacity(
                        opacity: normalize(opacity, 0.5, 1).clamp(0, 1), 
                        child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
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
