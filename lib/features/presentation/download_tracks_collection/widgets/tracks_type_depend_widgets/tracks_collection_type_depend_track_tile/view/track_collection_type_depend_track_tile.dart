import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/tracks_type_depend_widgets/tracks_collection_type_depend_track_tile/view/track_tile_status_button.dart';

class TracksCollectionTypeDependTrackTile extends StatelessWidget {
  const TracksCollectionTypeDependTrackTile(
      {super.key,
      required this.trackWithLoadingObserver,
      this.onDownloadButtonClicked,
      this.onCancelButtonClicked,
      this.onMoreInfoClicked,
      required this.isLoadedIfLoadingObserverIsNull,
      required this.type});

  final TracksCollectionType type;
  final TrackWithLoadingObserver trackWithLoadingObserver;
  final bool isLoadedIfLoadingObserverIsNull;
  final void Function()? onDownloadButtonClicked;
  final void Function()? onCancelButtonClicked;
  final void Function()? onMoreInfoClicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Builder(builder: (context) {
        if (type == TracksCollectionType.album || type == TracksCollectionType.track) {
          return Container();
        }

        return CachedNetworkImage(
          width: 50,
          height: 50,
          fit: BoxFit.fitWidth,
          memCacheHeight: (50 * MediaQuery.of(context).devicePixelRatio).round(),
          imageUrl: trackWithLoadingObserver.track.album?.imageUrl ?? '',
          placeholder: (context, imageUrl) =>
              Image.asset('resources/images/another/loading_track_collection_image.png'),
          errorWidget: (context, imageUrl, _) =>
              Image.asset('resources/images/another/loading_track_collection_image.png'),
        );
      }),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trackWithLoadingObserver.track.name,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              trackWithLoadingObserver.track.artists?.join(', ') ?? '',
              style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor),
            )
          ],
        ),
      )),
      TrackTileStatusButton(
          isLoadedIfLoadingObserverIsNull: isLoadedIfLoadingObserverIsNull,
          trackWithLoadingObserver: trackWithLoadingObserver,
          onCancelButtonClicked: onCancelButtonClicked,
          onDownloadButtonClicked: onDownloadButtonClicked),
      SizedBox(
          width: 30,
          height: 50,
          child: IconButton(
              onPressed: () {
                onMoreInfoClicked?.call();
              },
              icon: SvgPicture.asset(
                'resources/images/svg/track_tile/more_info.svg',
                fit: BoxFit.fitHeight,
              )))
    ]);
  }
}
