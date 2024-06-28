import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class DownloadTrackInfoTile extends StatefulWidget {
  const DownloadTrackInfoTile({
    super.key,
    required this.title,
    required this.iconWidget,
    this.onTap,
  });

  final String title;
  final Widget? iconWidget;
  final Function()? onTap;

  @override
  State<DownloadTrackInfoTile> createState() => _DownloadTrackInfoTileState();
}

class _DownloadTrackInfoTileState extends State<DownloadTrackInfoTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      splashColor: onSurfaceSplashColor,
      highlightColor: onSurfaceHighlightColor,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            widget.iconWidget ?? Container(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.title.replaceAll("\n", ""),
                  style: theme.textTheme.bodyMedium?.copyWith(color: onSurfacePrimaryColor),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
