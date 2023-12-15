import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class DownloadTrackInfoTile extends StatefulWidget {
  const DownloadTrackInfoTile({
    super.key,
    required this.title,
    this.svgAssetName,
    this.iconWidget,
    this.onTap, 
  });

  final String title;
  final Widget? iconWidget;
  final String? svgAssetName;
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
            Builder(
              builder: (context) {
                if (widget.iconWidget != null) {
                  return widget.iconWidget!;
                }

                return SvgPicture.asset(
                  widget.svgAssetName ?? '',
                  height: 23,
                  width: 23,
                  colorFilter: const ColorFilter.mode(onSurfaceSecondaryColor, BlendMode.srcIn),
                );
              }
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: onSurfacePrimaryColor),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
