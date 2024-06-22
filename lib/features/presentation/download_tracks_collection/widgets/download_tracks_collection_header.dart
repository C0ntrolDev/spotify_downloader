import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/widgets.dart';

class DownloadTracksCollectionHeader extends StatelessWidget {
  const DownloadTracksCollectionHeader(
      {super.key,
      required this.backgroundGradientColor,
      required this.title,
      required this.imageUrl,
      required this.onFilterQueryChanged,
      required this.onAllDownloadButtonClicked});

  final Color backgroundGradientColor;
  final String imageUrl;
  final String title;
  final void Function(String) onFilterQueryChanged;
  final void Function() onAllDownloadButtonClicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          backgroundGradientColor,
          backgroundColor,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20, bottom: 20),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Builder(builder: (context) {
                return Center(
                    child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  fit: BoxFit.contain,
                  imageUrl: imageUrl,
                  placeholder: (context, imageUrl) =>
                      Image.asset('resources/images/another/loading_track_collection_image.png'),
                  errorWidget: (context, imageUrl, _) =>
                      Image.asset('resources/images/another/loading_track_collection_image.png'),
                ));
              }),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TracksCollectionManageBar(
                      onFilterQueryChanged: onFilterQueryChanged,
                      onAllDownloadButtonClicked: onAllDownloadButtonClicked)),
            ])));
  }
}
