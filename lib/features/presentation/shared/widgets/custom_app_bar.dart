import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = appBarHeight
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height + MediaQuery.of(context).viewPadding.top,
      child: Padding(
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
                  height: backIconSize,
                  width: backIconSize,
                )),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall,
                )),
          ],
        ),
      ),
    );
  }
}
