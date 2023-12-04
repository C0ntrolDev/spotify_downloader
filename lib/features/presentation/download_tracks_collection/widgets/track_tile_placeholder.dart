import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class TrackTilePlaceholder extends StatefulWidget {
  const TrackTilePlaceholder({
    super.key,
  });

  @override
  State<TrackTilePlaceholder> createState() => _TrackTilePlaceholderState();
}

class _TrackTilePlaceholderState extends State<TrackTilePlaceholder> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'resources/images/another/loading_track_collection_image.png',
              width: 50,
              height: 50,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((theme.textTheme.bodyMedium?.fontSize ?? 0) * 0.3),
                        color: tilePlaceholderColor),
                    height: theme.textTheme.bodyMedium?.fontSize,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((theme.textTheme.labelLarge?.fontSize ?? 0) * 0.3),
                          color: tilePlaceholderColor),
                      height: theme.textTheme.labelLarge?.fontSize,
                      width: 130,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
