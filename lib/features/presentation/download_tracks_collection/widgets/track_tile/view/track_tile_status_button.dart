import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/shared/cubits/track_loading_observing_cubit/download_track_info_status_tile_cubit.dart';
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
  final _trackLoadingObservingCubit = injector.get<TrackLoadingObservingCubit>();

  @override
  void initState() {
    _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TrackTileStatusButton oldWidget) {
    if (oldWidget.trackWithLoadingObserver != widget.trackWithLoadingObserver) {
      _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
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
                child: BlocBuilder<TrackLoadingObservingCubit, TrackLoadingObservingState>(
                  bloc: _trackLoadingObservingCubit,
                  builder: (context, state) {
                    if (state is TrackLoadingObservingLoading) {
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

                    if (state is TrackLoadingObservingFailure) {
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
                child: BlocBuilder<TrackLoadingObservingCubit, TrackLoadingObservingState>(
                  bloc: _trackLoadingObservingCubit,
                  builder: (context, state) {
                    if (state is TrackLoadingObservingDeffault) {
                      return GestureDetector(
                          onTap: () {
                            widget.onDownloadButtonClicked?.call();
                          },
                          child: SvgPicture.asset('resources/images/svg/track_tile/download_icon.svg',
                              height: 35, width: 35));
                    }

                    if (state is TrackLoadingObservingLoading) {
                      if (state.percent == null) {
                        return Container(
                            padding: const EdgeInsets.all(0),
                            height: 32,
                            width: 32,
                            child:
                                const StrangeOptimizedCircularProgressIndicator(strokeWidth: 4));
                      }

                      return Container(
                        padding: const EdgeInsets.all(0),
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          value: state.percent! / 100
                        ),
                      );
                    }

                    if (state is TrackLoadingObservingLoaded) {
                      return SvgPicture.asset(
                        'resources/images/svg/track_tile/downloaded_icon.svg',
                        height: 35,
                        width: 35
                      );
                    }

                    if (state is TrackLoadingObservingFailure) {
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
