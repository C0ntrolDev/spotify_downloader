import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/cubit/download_track_info_cubit.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/widgets/download_track_info_status_tile/view/download_track_info_status_tile.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/widgets/download_track_info_tile.dart';
import 'package:spotify_downloader/generated/l10n.dart';

void showDownloadTrackInfoBottomSheet(BuildContext context, TrackWithLoadingObserver trackWithLoadingObserver) {
  showMaterialModalBottomSheet(
      elevation: 0,
      backgroundColor: surfaceColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      bounce: true,
      builder: (buildContext) {
        return DownloadTrackInfo(
          trackWithLoadingObserver: trackWithLoadingObserver,
        );
      });
}

class DownloadTrackInfo extends StatefulWidget {
  const DownloadTrackInfo({super.key, required this.trackWithLoadingObserver});

  final TrackWithLoadingObserver trackWithLoadingObserver;

  @override
  State<DownloadTrackInfo> createState() => _DownloadTrackInfoState();
}

class _DownloadTrackInfoState extends State<DownloadTrackInfo> {
  late final DownloadTrackInfoCubit _downloadTrackInfoCubit = injector.get<DownloadTrackInfoCubit>();

  @override
  Widget build(BuildContext context) {
    final track = widget.trackWithLoadingObserver.track;

    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration:
                        BoxDecoration(color: onSurfaceSecondaryColor, borderRadius: BorderRadius.circular(2.5)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 50,
                          height: 50,
                          fit: BoxFit.fitWidth,
                          memCacheWidth: (50 * MediaQuery.of(context).devicePixelRatio).round(),
                          imageUrl: track.album?.imageUrl ?? '',
                          placeholder: (context, imageUrl) =>
                              Image.asset('resources/images/another/loading_track_collection_image.png'),
                          errorWidget: (context, imageUrl, _) =>
                              Image.asset('resources/images/another/loading_track_collection_image.png'),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: theme.textTheme.bodyMedium,
                              ),
                              LayoutBuilder(builder: (context, constrains) {
                                return Row(children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: constrains.maxWidth / 2),
                                    child: Text(
                                      track.artists?.join(', ') ?? '',
                                      style: theme.textTheme.labelLarge?.copyWith(color: onSurfaceSecondaryColor),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                            color: onSurfaceSecondaryColor, shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      track.album?.name ?? '',
                                      style: theme.textTheme.labelLarge?.copyWith(color: onSurfaceSecondaryColor),
                                    ),
                                  ),
                                ]);
                              }),
                            ],
                          ),
                        )),
                      ],
                    )),
                const Divider(color: onSurfaceSecondaryColor, height: 20, thickness: 0.3),
                DownloadTrackInfoStatusTile(trackWithLoadingObserver: widget.trackWithLoadingObserver),
                DownloadTrackInfoTile(
                    title: S.of(context).linkToTheSource,
                    iconWidget: SvgPicture.asset('resources/images/svg/download_track_info/reference_icon.svg',
                        height: 23,
                        width: 23,
                        colorFilter: const ColorFilter.mode(onSurfaceSecondaryColor, BlendMode.srcIn)),
                    onTap: () async {
                      if (track.youtubeUrl != null) {
                        showSnackBar(S.of(context).urlCopied, context);
                        await Clipboard.setData(ClipboardData(text: track.youtubeUrl!));
                      } else {
                        showSnackBar(S.of(context).urlNotSelected, context);
                      }
                    }),
                DownloadTrackInfoTile(
                  title: S.of(context).changeTheSource,
                  iconWidget: SvgPicture.asset('resources/images/svg/download_track_info/edit_icon.svg',
                      height: 23,
                      width: 23,
                      colorFilter: const ColorFilter.mode(onSurfaceSecondaryColor, BlendMode.srcIn)),
                  onTap: () async {
                    final changedUrl =
                        await AutoRouter.of(context).push<String?>(ChangeSourceVideoRoute(track: track));
                    if (changedUrl != null) {
                      _downloadTrackInfoCubit.changeTrackYoutubeUrl(
                          trackWithLoadingObserver: widget.trackWithLoadingObserver, newYoutubeUrl: changedUrl);
                    }
                  },
                )
              ])),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String message, BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    showBigTextSnackBar(message, context);
  }
}
