import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/cubit/loading_tracks_collection_tile_cubit.dart';

class LoadingTracksCollectionTile extends StatefulWidget {
  const LoadingTracksCollectionTile({super.key, required this.loadingTracksCollection});

  final LoadingTracksCollectionObserver loadingTracksCollection;

  @override
  State<LoadingTracksCollectionTile> createState() => _LoadingTracksCollectionTileState();
}

class _LoadingTracksCollectionTileState extends State<LoadingTracksCollectionTile> {
  late final LoadingTracksCollectionTileCubit _cubit;

  @override
  void initState() {
    _cubit = injector.get<LoadingTracksCollectionTileCubit>(param1: widget.loadingTracksCollection);
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LoadingTracksCollectionTileCubit, LoadingTracksCollectionTileState>(
      bloc: _cubit,
      buildWhen: (previous, current) => current is LoadingTracksCollectionTileChanged,
      builder: (context, state) {
        if (state is! LoadingTracksCollectionTileChanged) return Container();

        final totalTracks = state.loadingTrackInfo.totalTracks;
        final loadedTracks = state.loadingTrackInfo.loadedTracks;
        final failureTracks = state.loadingTrackInfo.failuredTracks;

        double? errorProgressIndicatorValue = 0;
        double? loadedProgressIndicatorValue = 0;

        if (state.loadingTrackInfo.loadingTracks == totalTracks) {
          errorProgressIndicatorValue = 0;
          loadedProgressIndicatorValue = null;
        } else {
          errorProgressIndicatorValue = (loadedTracks + failureTracks) / totalTracks;
          loadedProgressIndicatorValue = loadedTracks / totalTracks;
        }

        return InkWell(
          splashColor: onSurfaceSplashColor,
          highlightColor: onSurfaceHighlightColor,
          onTap: () {
            if (state.loadingTrackInfo.tracksCollection == null) return;

            AutoRouter.of(context).push(DownloadTracksCollectionRouteWithHistoryTracksCollection(
                historyTracksCollection: HistoryTracksCollection(
                    spotifyId: state.loadingTrackInfo.tracksCollection!.spotifyId,
                    type: state.loadingTrackInfo.tracksCollection!.type,
                    name: state.loadingTrackInfo.tracksCollection!.name)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: state.loadingTrackInfo.tracksCollection?.bigImageUrl ?? '',
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
                        state.loadingTrackInfo.tracksCollection?.name ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        state.loadingTrackInfo.tracksCollection?.artists?.join(', ') ?? '',
                        style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor),
                      )
                    ],
                  ),
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${((loadedProgressIndicatorValue ?? 0) * 100).toInt()}%',
                    ),
                    Text(
                      '$loadedTracks/$totalTracks',
                      style: theme.textTheme.labelMedium?.copyWith(color: onBackgroundSecondaryColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 4),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 4,
                          color: errorPrimaryColor,
                          value: errorProgressIndicatorValue,
                        ),
                        CircularProgressIndicator(
                          strokeWidth: 4,
                          color: primaryColor,
                          value: loadedProgressIndicatorValue,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
