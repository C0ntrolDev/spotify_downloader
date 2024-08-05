import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';

class LikedTracksTile extends StatelessWidget {
  const LikedTracksTile({
    super.key,
    required this.theme,
    required this.title,
    required this.image,
    this.onTap,
  });

  final String title;
  final ImageProvider<Object> image;
  final void Function()? onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TapAnimatedContainer(
        tappingMaskColor: surfaceColor.withOpacity(0.4),
        tappingScale: 0.99,
        onTap: onTap,
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
        ));
  }
}
