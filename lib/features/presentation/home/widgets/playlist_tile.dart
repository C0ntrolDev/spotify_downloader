import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({
    super.key,
    required this.theme,
    required this.title,
    required this.image,
    this.onTapped,
  });

  final String title;
  final ImageProvider<Object> image;
  final Function? onTapped;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapped?.call();
      },
      child: Container(
        width: 180,
        height: 55,
        decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Container(
              width: 55,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                  image: DecorationImage(image: image)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  title,
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
