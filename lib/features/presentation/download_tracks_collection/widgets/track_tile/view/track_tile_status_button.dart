import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/cubit/track_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/strange_optimized_circular_progress_indicator.dart';

class TrackTileStatusButton extends StatefulWidget {
  const TrackTileStatusButton(
      {super.key, required this.trackWithLoadingObserver, this.onDownloadButtonClicked, this.onCancelButtonClicked});

  final TrackWithLoadingObserver trackWithLoadingObserver;
  final void Function()? onDownloadButtonClicked;
  final void Function()? onCancelButtonClicked;

  @override
  State<TrackTileStatusButton> createState() => _TrackTileStatusButtonState();
}

class _TrackTileStatusButtonState extends State<TrackTileStatusButton> {
  final _trackTileCubit = injector.get<TrackTileCubit>();

  @override
  void initState() {
    _trackTileCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TrackTileStatusButton oldWidget) {
    if (oldWidget.trackWithLoadingObserver != widget.trackWithLoadingObserver) {
      _trackTileCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.only(right: 10),
                child: BlocBuilder<TrackTileCubit, TrackTileState>(
                  bloc: _trackTileCubit,
                  builder: (context, state) {
                    if (state is TrackTileLoading) {
                      return GestureDetector(
                        onTap: () {
                          widget.onCancelButtonClicked?.call();
                        },
                        child: SvgPicture.asset(
                          'resources/images/svg/track_tile/cancel_icon.svg',
                          height: 28,
                          width: 28,
                        ),
                      );
                    }

                    if (state is TrackTileFailure) {
                      return GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'resources/images/svg/track_tile/error_icon.svg',
                          height: 32,
                          width: 32,
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
                child: BlocBuilder<TrackTileCubit, TrackTileState>(
                  bloc: _trackTileCubit,
                  builder: (context, state) {
                    if (state is TrackTileDeffault) {
                      return GestureDetector(
                          onTap: () {
                            widget.onDownloadButtonClicked?.call();
                          },
                          child: SvgPicture.asset('resources/images/svg/track_tile/download_icon.svg',
                              height: 35, width: 35));
                    }

                    if (state is TrackTileLoading) {
                      if (state.percent == null) {
                        return Container(
                            padding: const EdgeInsets.all(0),
                            height: 32,
                            width: 32,
                            child:
                                const StrangeOptimizedCircularProgressIndicator(strokeWidth: 4, color: primaryColor));
                      }

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

                    if (state is TrackTileLoaded) {
                      return SvgPicture.asset(
                        'resources/images/svg/track_tile/downloaded_icon.svg',
                        height: 35,
                        width: 35
                      );
                    }

                    if (state is TrackTileFailure) {
                      return GestureDetector(
                        onTap: () => widget.onDownloadButtonClicked?.call(),
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
        )
      ],
    );
  }
}