import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoasts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/utils/failures/failures.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/widgets/download_track_info_tile.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/shared/cubits/track_loading_observing_cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/strange_optimized_circular_progress_indicator.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class DownloadTrackInfoStatusTile extends StatefulWidget {
  const DownloadTrackInfoStatusTile(
      {super.key, required this.trackWithLoadingObserver, required this.isLoadedIfLoadingObserverIsNull});

  final TrackWithLoadingObserver trackWithLoadingObserver;
  final bool isLoadedIfLoadingObserverIsNull;

  @override
  State<DownloadTrackInfoStatusTile> createState() => _DownloadTrackInfoStatusTileState();
}

class _DownloadTrackInfoStatusTileState extends State<DownloadTrackInfoStatusTile> {
  late final TrackLoadingObservingCubit _trackLoadingObservingCubit = injector.get<TrackLoadingObservingCubit>();

  @override
  void initState() {
    _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
    _trackLoadingObservingCubit.changeIsLoadedIfLoadingObserverIsNull(widget.isLoadedIfLoadingObserverIsNull);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DownloadTrackInfoStatusTile oldWidget) {
    if (oldWidget.trackWithLoadingObserver != widget.trackWithLoadingObserver ||
        oldWidget.isLoadedIfLoadingObserverIsNull != widget.isLoadedIfLoadingObserverIsNull) {
      _trackLoadingObservingCubit.changeTrackWithLoadingObserver(widget.trackWithLoadingObserver);
      _trackLoadingObservingCubit.changeIsLoadedIfLoadingObserverIsNull(widget.isLoadedIfLoadingObserverIsNull);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackLoadingObservingCubit, TrackLoadingObservingState>(
      bloc: _trackLoadingObservingCubit,
      builder: (context, state) {
        if (state is TrackLoadingObservingDefault) {
          return DownloadTrackInfoTile(
              title: S.of(context).theTrackIsNotLoaded,
              iconWidget:
                  SvgPicture.asset('resources/images/svg/track_tile/download_icon.svg', height: 23, width: 23));
        }

        if (state is TrackLoadingObservingLoading) {
          return DownloadTrackInfoTile(
            title: S.of(context).theTrackIsLoading(state.percent != null ? formatDouble(state.percent!) : '...'),
            iconWidget: Container(
              padding: const EdgeInsets.all(0),
              height: 23,
              width: 23,
              child: Builder(builder: (context) {
                if (state.percent == null) {
                  return const StrangeOptimizedCircularProgressIndicator(
                    strokeWidth: 3,
                  );
                }

                return CircularProgressIndicator(strokeWidth: 3, value: state.percent! / 100);
              }),
            ),
          );
        }

        if (state is TrackLoadingObservingLoaded) {
          return DownloadTrackInfoTile(
              title: S.of(context).theTrackIsLoaded,
              iconWidget:
                  SvgPicture.asset('resources/images/svg/track_tile/downloaded_icon.svg', height: 23, width: 23));
        }

        if (state is TrackLoadingObservingFailure) {
          return DownloadTrackInfoTile(
              title: S.of(context).downloadError(
                  state.failure is NetworkFailure ? S.of(context).noConnection : state.failure ?? '...'),
              iconWidget: SvgPicture.asset('resources/images/svg/track_tile/error_icon.svg', height: 23, width: 23),
              onTap: () async {
                if (state.failure != null) {
                  showSnackBar(S.of(context).failureCopied, context);
                  await Clipboard.setData(ClipboardData(text: state.failure!.toString()));
                }
              });
        }

        return Container();
      },
    );
  }

  String formatDouble(double value) {
    final splittedValue = value.toString().split('.');
    final intPart = value.truncate().toString();

    String? doublePart;
    if (splittedValue.length == 2) {
      doublePart = splittedValue[1];
    }

    if (doublePart != null && doublePart.isNotEmpty) {
      return '$intPart.${doublePart.substring(0, min(doublePart.length, 2))}';
    } else {
      return intPart;
    }
  }

  void showSnackBar(String message, BuildContext context) async {
    final ftoast = FtoastAccessor.of(context).fToast;
    ftoast.removeCustomToast();
    ftoast.removeQueuedCustomToasts();

    showBigTextSnackBar(context, message);
  }
}
