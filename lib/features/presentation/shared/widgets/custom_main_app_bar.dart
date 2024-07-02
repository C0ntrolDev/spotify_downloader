import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';

class CustomMainAppBar extends StatelessWidget {
  const CustomMainAppBar({
    super.key,
    required this.title,
    this.icon,
  });

  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: appBarHeight,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title, style: theme.textTheme.titleLarge), if (icon != null) icon!],
        ),
      ),
    );
  }
}
