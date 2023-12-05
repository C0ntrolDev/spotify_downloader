import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
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
                    imageUrl: state.track.imageUrl ?? '',
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
                          overflow: TextOverflow.ellipsis,
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
          padding: const EdgeInsets.only(left: 25, right: 13),
          child: BlocBuilder<TrackTileBloc, TrackTileState>(
            bloc: _trackTileBloc,
            builder: (context, state) {
              if (state is TrackTileDeffault) {
                return GestureDetector(
                    onTap: () {
                      _trackTileBloc.add(TrackTitleDownloadTrack());
                    },
                    child: SvgPicture.asset('resources/images/svg/download_icon.svg', height: 30, width: 30));
              }

              if (state is TrackTileOnTrackLoading) {
                return GestureDetector(
                  onTap: () => _trackTileBloc.add(TrackTileCancelTrackLoading()),
                  child: Container(
                    height: 27,
                    width: 27,
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
                  ),
                );
              }

              if (state is TrackTileOnTrackLoaded) {
                return SvgPicture.asset(
                  'resources/images/svg/downloaded_icon.svg',
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                );
              }

              if (state is TrackTileTrackOnFailure) {
                return GestureDetector(
                  onTap: () => _trackTileBloc.add(TrackTitleDownloadTrack()),
                  child: SvgPicture.asset(
                    'resources/images/svg/error_icon.svg',
                    height: 30,
                    width: 30,
                    colorFilter: const ColorFilter.mode(errorPrimaryColor, BlendMode.srcIn),
                  ),
                );
              }

              return Container();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
              width: 20,
              height: 50,
              child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'resources/images/svg/more_info.svg',
                    fit: BoxFit.fitHeight,
                  ))),
        )
      ],
    );
  }
}