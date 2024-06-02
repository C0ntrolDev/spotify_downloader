import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/view/download_track_info.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/bloc/track_tile_bloc.dart';

class TrackTile extends StatefulWidget {
  const TrackTile({super.key, required this.trackWithLoadingObserver});

  final TrackWithLoadingObserver trackWithLoadingObserver;

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  late final TrackTileBloc _trackTileBloc;

  @override
  void initState() {
    _trackTileBloc = injector.get<TrackTileBloc>(param1: widget.trackWithLoadingObserver);
    super.initState();
  }

  @override
  void dispose() {
    _trackTileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: BlocBuilder<TrackTileBloc, TrackTileState>(
            bloc: _trackTileBloc,
            builder: (context, state) {
              return Row(
                children: [
                  CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: state.track.album?.imageUrl ?? '',
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
                          state.track.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          state.track.artists?.join(', ') ?? '',
                          style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor),
                        )
                      ],
                    ),
                  )),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.only(right: 10),
                child: BlocBuilder<TrackTileBloc, TrackTileState>(
                  bloc: _trackTileBloc,
                  builder: (context, state) {
                    if (state is TrackTileTrackLoading) {
                      return GestureDetector(
                        onTap: () {
                          _trackTileBloc.add(TrackTileCancelTrackLoading());
                        },
                        child: SvgPicture.asset(
                          'resources/images/svg/track_tile/cancel_icon.svg',
                          height: 28,
                          width: 28,
                        ),
                      );
                    }

                    if (state is TrackTileTrackFailure) {
                      return GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'resources/images/svg/track_tile/error_icon.svg',
                          height: 32,
                          width: 32,
                          colorFilter: const ColorFilter.mode(errorPrimaryColor, BlendMode.srcIn),
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.only(right: 10),
                child: BlocBuilder<TrackTileBloc, TrackTileState>(
                  bloc: _trackTileBloc,
                  builder: (context, state) {
                    if (state is TrackTileDeffault) {
                      return GestureDetector(
                          onTap: () {
                            _trackTileBloc.add(TrackTitleDownloadTrack());
                          },
                          child: SvgPicture.asset('resources/images/svg/track_tile/download_icon.svg',
                              height: 35, width: 35));
                    }

                    if (state is TrackTileTrackLoading) {
                      return Container(
                        padding: const EdgeInsets.all(0),
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: primaryColor,
                          value: (() {
                            if (state.percent != null) {
                              return state.percent! / 100;
                            }

                            return null;
                          }).call(),
                        ),
                      );
                    }

                    if (state is TrackTileTrackLoaded) {
                      return SvgPicture.asset(
                        'resources/images/svg/track_tile/downloaded_icon.svg',
                        height: 35,
                        width: 35,
                        colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                      );
                    }

                    if (state is TrackTileTrackFailure) {
                      return GestureDetector(
                        onTap: () => _trackTileBloc.add(TrackTitleDownloadTrack()),
                        child: SvgPicture.asset(
                          'resources/images/svg/track_tile/reload_icon.svg',
                          height: 32,
                          width: 32,
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: BlocBuilder<TrackTileBloc, TrackTileState>(
            bloc: _trackTileBloc,
            builder: (context, state) {
              return SizedBox(
                  width: 30,
                  height: 50,
                  child: IconButton(
                      onPressed: () {
                        showDownloadTrackInfoBottomSheet(context, state.trackWithLoadingObserver);
                      },
                      icon: SvgPicture.asset(
                        'resources/images/svg/track_tile/more_info.svg',
                        fit: BoxFit.fitHeight,
                      )));
            },
          ),
        )
      ],
    );
  }
}
