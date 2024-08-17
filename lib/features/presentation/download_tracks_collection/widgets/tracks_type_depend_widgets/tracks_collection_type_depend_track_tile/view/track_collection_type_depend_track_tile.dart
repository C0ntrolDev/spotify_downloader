import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/shared/cubits/track_loading_observing_cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';

class TracksCollectionTypeDependTrackTile extends StatefulWidget {
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
  State<TracksCollectionTypeDependTrackTile> createState() => _TracksCollectionTypeDependTrackTileState();
}

class _TracksCollectionTypeDependTrackTileState extends State<TracksCollectionTypeDependTrackTile> {
  final _trackLoadingObservingCubit = injector.get<TrackLoadingObservingCubit>();

  @override
  void initState() {
    _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
    _trackLoadingObservingCubit.changeIsLoadedIfLoadingObserverIsNull(widget.isLoadedIfLoadingObserverIsNull);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TracksCollectionTypeDependTrackTile oldWidget) {
    if (oldWidget.trackWithLoadingObserver != widget.trackWithLoadingObserver ||
        oldWidget.isLoadedIfLoadingObserverIsNull != widget.isLoadedIfLoadingObserverIsNull) {
      _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
      _trackLoadingObservingCubit.changeIsLoadedIfLoadingObserverIsNull(widget.isLoadedIfLoadingObserverIsNull);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TapAnimatedContainer(
      tappingScale: 0.99,
      tappingMaskColor: backgroundColor.withOpacity(0.4),
      onTap: onTrackTileClicked,
      onLongTapStart: widget.onMoreInfoClicked,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Builder(builder: (context) {
          if (widget.type == TracksCollectionType.album || widget.type == TracksCollectionType.track) {
            return Container();
          }
      
          return CachedNetworkImage(
            width: 50,
            height: 50,
            fit: BoxFit.fitWidth,
            memCacheHeight: (50 * MediaQuery.of(context).devicePixelRatio).round(),
            imageUrl: widget.trackWithLoadingObserver.track.album?.imageUrl ?? '',
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
                widget.trackWithLoadingObserver.track.name,
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                widget.trackWithLoadingObserver.track.artists?.join(', ') ?? '',
                style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor),
              )
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.only(right: 10),
                child: BlocBuilder<TrackLoadingObservingCubit, TrackLoadingObservingState>(
                  bloc: _trackLoadingObservingCubit,
                  builder: (context, state) {
                    return TrackTileFailureCancelStatusButton(state: state);
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 50,
                child: BlocBuilder<TrackLoadingObservingCubit, TrackLoadingObservingState>(
                  bloc: _trackLoadingObservingCubit,
                  builder: (context, state) {
                    return TrackTileLoadingStatusButton(state: state);
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
            width: 30,
            height: 50,
            child: IconButton(
                onPressed: () {
                  widget.onMoreInfoClicked?.call();
                },
                icon: SvgPicture.asset(
                  'resources/images/svg/track_tile/more_info.svg',
                  fit: BoxFit.fitHeight,
                )))
      ]),
    );
  }

  void onTrackTileClicked() {
    switch (_trackLoadingObservingCubit.state) {
      case TrackLoadingObservingDefault():
        widget.onDownloadButtonClicked?.call();
      case TrackLoadingObservingFailure():
        widget.onDownloadButtonClicked?.call();
      default:
        break;
    }
  }
}

class TrackTileFailureCancelStatusButton extends StatelessWidget {
  const TrackTileFailureCancelStatusButton({super.key, required this.state});

  final TrackLoadingObservingState state;

  @override
  Widget build(BuildContext context) {
    if (state is TrackLoadingObservingLoading) {
      return SvgPicture.asset(
        'resources/images/svg/track_tile/cancel_icon.svg',
        height: 28,
        width: 28,
      );
    }

    if (state is TrackLoadingObservingFailure) {
      return SvgPicture.asset(
        'resources/images/svg/track_tile/error_icon.svg',
        height: 32,
        width: 32,
      );
    }

    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        height: 32, width: 32,
      ),
    );
  }
}

class TrackTileLoadingStatusButton extends StatelessWidget {
  const TrackTileLoadingStatusButton({super.key, required this.state});

  final TrackLoadingObservingState state;

  @override
  Widget build(BuildContext context) {
    if (state is TrackLoadingObservingDefault) {
      return SvgPicture.asset('resources/images/svg/track_tile/download_icon.svg', height: 35, width: 35);
    }

    if (state is TrackLoadingObservingLoading) {
      final percent = (state as TrackLoadingObservingLoading).percent;
      if (percent == null) {
        return Container(
            padding: const EdgeInsets.all(0),
            height: 32,
            width: 32,
            child: const StrangeOptimizedCircularProgressIndicator(strokeWidth: 4));
      }

      return Container(
        padding: const EdgeInsets.all(0),
        height: 32,
        width: 32,
        child: CircularProgressIndicator(strokeWidth: 4, value: percent / 100),
      );
    }

    if (state is TrackLoadingObservingLoaded) {
      return SvgPicture.asset('resources/images/svg/track_tile/downloaded_icon.svg', height: 35, width: 35);
    }

    if (state is TrackLoadingObservingFailure) {
      return SvgPicture.asset(
        'resources/images/svg/track_tile/reload_icon.svg',
        height: 32,
        width: 32,
      );
    }

    return Container();
  }
}
