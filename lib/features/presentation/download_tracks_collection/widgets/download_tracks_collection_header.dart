import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/widgets.dart';


class DownloadTracksCollectionHeader extends StatelessWidget {
  const DownloadTracksCollectionHeader(
      {super.key,
      required this.backgroundGradientColor,
      required this.imageUrl,
      required this.title,
      required this.onFilterQueryChanged,
      required this.onDownloadAllButtonClicked});

  final Color backgroundGradientColor;
  final String imageUrl;
  final String title;
  final void Function(String newQuery) onFilterQueryChanged;
  final void Function() onDownloadAllButtonClicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverStack(children: [
      SliverPositioned.fill(child: Builder(builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            backgroundGradientColor,
            backgroundColor,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );
      })),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: MultiSliver(children: [
          SliverPersistentHeader(
              delegate: CustomSliverPersistentHeaderDelegate(
            maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
            minHeight: 0,
            child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  final minImageSize =
                      min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.3;
                  final imageSize = max(minImageSize, constraints.maxHeight);

                  double opacity;
                  if (imageSize != minImageSize) {
                    opacity = 1;
                  } else {
                    opacity = normalize(constraints.maxHeight, minImageSize / 2, minImageSize).clamp(0, 1);
                  }

                  return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                    Positioned(
                      width: imageSize,
                      height: imageSize,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 7,
                              blurRadius: 13,
                            )
                          ]),
                          child: CachedNetworkImage(
                            height: imageSize,
                            fit: BoxFit.contain,
                            imageUrl: imageUrl,
                            placeholder: (context, imageUrl) =>
                                Image.asset('resources/images/another/loading_track_collection_image.png'),
                            errorWidget: (context, imageUrl, _) =>
                                Image.asset('resources/images/another/loading_track_collection_image.png'),
                          ),
                        ),
                      ),
                    )
                  ]);
                })),
          )),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )),
          ),
          DownloadTracksCollectionManageBar(
              onFilterQueryChanged: onFilterQueryChanged, onDownloadAllButtonClicked: onDownloadAllButtonClicked)
        ]),
      )
    ]);
  }
}
