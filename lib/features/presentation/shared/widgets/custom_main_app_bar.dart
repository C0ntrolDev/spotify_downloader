import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';

class CustomMainAppBar extends StatelessWidget {
  const CustomMainAppBar({
    super.key,
    required this.title,
    this.icon,
    this.color = backgroundColor,
    this.contentPadding,
  });

  final String title;
  final Widget? icon;
  final Color color;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        color: color,
        padding: contentPadding ?? EdgeInsets.zero,
        child: Container(
          height: appBarHeight,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title, style: theme.textTheme.titleLarge), if (icon != null) icon!],
          ),
        ),
      ),
    );
  }
}
