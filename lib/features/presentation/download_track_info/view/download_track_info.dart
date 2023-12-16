import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/bloc/download_track_info_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/widgets/download_track_info_status_tile/view/download_track_info_status_tile.dart';

import '../widgets/download_track_info_tile.dart';

void showDownloadTrackInfoBottomSheet(BuildContext context, TrackWithLoadingObserver trackWithLoadingObserver) {
  showModalBottomSheet(
      backgroundColor: surfaceColor,
      context: context,
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
  late final DownloadTrackInfoBloc _downloadTrackInfoBloc;

  @override
  void initState() {
    super.initState();
    _downloadTrackInfoBloc = injector.get<DownloadTrackInfoBloc>(param1: widget.trackWithLoadingObserver);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 290,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BlocBuilder<DownloadTrackInfoBloc, DownloadTrackInfoState>(
            bloc: _downloadTrackInfoBloc,
            builder: (context, state) {
              return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 50,
                          height: 50,
                          imageUrl: state.trackWithLoadingObserver.track.album?.imageUrl ?? '',
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
                                state.trackWithLoadingObserver.track.name,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Flex(direction: Axis.horizontal, children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  flex: 1,
                                  child: Text(
                                    state.trackWithLoadingObserver.track.artists?.join(', ') ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelLarge?.copyWith(color: onSurfaceSecondaryColor),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration:
                                          const BoxDecoration(color: onSurfaceSecondaryColor, shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Text(
                                    state.trackWithLoadingObserver.track.album?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelLarge?.copyWith(color: onSurfaceSecondaryColor),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        )),
                      ],
                    )),
                const Divider(color: onSurfaceSecondaryColor, height: 20),
                DownloadTrackInfoStatusTile(trackWithLoadingObserver: state.trackWithLoadingObserver),
                DownloadTrackInfoTile(
                    title: 'Ссылка на источник',
                    iconWidget: SvgPicture.asset('resources/images/svg/download_track_info/reference_icon.svg',
                        height: 23,
                        width: 23,
                        colorFilter: const ColorFilter.mode(onSurfaceSecondaryColor, BlendMode.srcIn)),
                    onTap: () async {
                      if (state.trackWithLoadingObserver.track.youtubeUrl != null) {
                        showSnackBar('Url скопирован!', context);
                        await Clipboard.setData(ClipboardData(text: state.trackWithLoadingObserver.track.youtubeUrl!));
                      } else {
                        showSnackBar('Url не выбран', context);
                      }
                    }),
                DownloadTrackInfoTile(
                  title: 'Изменить источник',
                  iconWidget: SvgPicture.asset('resources/images/svg/download_track_info/edit_icon.svg',
                      height: 23,
                      width: 23,
                      colorFilter: const ColorFilter.mode(onSurfaceSecondaryColor, BlendMode.srcIn)),
                  onTap: () {},
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      duration: const Duration(seconds: 2),
    ));
  }
}
