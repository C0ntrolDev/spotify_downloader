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

    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
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
            padding: const EdgeInsets.only(right: 10),
            child: BlocBuilder<TrackTileBloc, TrackTileState>(
              bloc: _trackTileBloc,
              builder: (context, state) {
                if (state is TrackTileDeffault) {
                  return IconButton(
                      onPressed: () {
                        _trackTileBloc.add(TrackTitleDownloadTrack());
                      },
                      icon: SvgPicture.asset('resources/images/svg/download_icon.svg', height: 27, width: 27));
                }
            
                if (state is TrackTileTrackLoading) {
                  return SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      value: ((state.percent ?? 0) / 100),
                    ),
                  );
                }
            
                if (state is TrackTileOnTrackLoaded) {
                  return SvgPicture.asset('resources/images/svg/downloaded_icon.svg', height: 27, width: 27);
                }
            
                if (state is TrackTileTrackOnFailure) {
                  print(state.failure);
                  return Container(color: Colors.red, height: 30, width: 30);
                }
            
                return Container();
              },
            ),
          ),
          SizedBox(
              width: 20,
              height: 50,
              child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'resources/images/svg/more_info.svg',
                    fit: BoxFit.fitHeight,
                  )))
        ],
      ),
    );
  }
}
