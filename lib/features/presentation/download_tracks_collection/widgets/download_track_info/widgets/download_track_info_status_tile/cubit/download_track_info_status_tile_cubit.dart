import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';

part 'download_track_info_status_tile_state.dart';

class DownloadTrackInfoStatusTileCubit extends Cubit<DownloadTrackInfoStatusTileState> {
  final TrackWithLoadingObserver _trackWithLoadingObserver;
  final List<StreamSubscription> _loadingTrackObserverSubscriptions = List.empty(growable: true);
  StreamSubscription? _loadingTrackObserverChangedSubscription;

  DownloadTrackInfoStatusTileCubit(TrackWithLoadingObserver trackWithLoadingObserver)
      : _trackWithLoadingObserver = trackWithLoadingObserver,
        super(_selectStateBasedOnLoadingObserver(trackWithLoadingObserver)) {
    _loadingTrackObserverChangedSubscription =
        _trackWithLoadingObserver.onLoadingTrackObserverChangedStream.listen((loadingObserver) async {
      await unsubscribeFromLoadingTrackObserver();
      emit(_selectStateBasedOnLoadingObserver(_trackWithLoadingObserver));
      if (_trackWithLoadingObserver.loadingObserver != null) {
        subscribeToLoadingTrackObserver(_trackWithLoadingObserver.loadingObserver!);
      }
    });

    if (_trackWithLoadingObserver.loadingObserver != null) {
      subscribeToLoadingTrackObserver(_trackWithLoadingObserver.loadingObserver!);
    }
  }

  @override
  Future<void> close() async {
    await unsubscribeFromLoadingTrackObserver();
    await _loadingTrackObserverChangedSubscription?.cancel();
    return super.close();
  }

  void subscribeToLoadingTrackObserver(LoadingTrackObserver loadingTrackObserver) {
    if ((loadingTrackObserver.status == LoadingTrackStatus.waitInLoadingQueue ||
        loadingTrackObserver.status == LoadingTrackStatus.loading)) {
      final sub1 = loadingTrackObserver.loadingPercentChangedStream
          .listen((percent) => emit(DownloadTrackInfoStatusTileLoading(percent: percent)));
      final sub2 = loadingTrackObserver.loadingCancelledStream
          .listen((event) => emit(const DownloadTrackInfoStatusTileDeffault()));
      final sub3 = loadingTrackObserver.loadingFailureStream
          .listen((failure) => emit(DownloadTrackInfoStatusTileFailure(failure: failure)));
      final sub4 =
          loadingTrackObserver.loadedStream.listen((event) => emit(const DownloadTrackInfoStatusTileLoaded()));

      _loadingTrackObserverSubscriptions.addAll([sub1, sub2, sub3, sub4]);
    }
  }

  Future<void> unsubscribeFromLoadingTrackObserver() async {
    for (var loadingTrackObserverSubscription in _loadingTrackObserverSubscriptions) {
      await loadingTrackObserverSubscription.cancel();
    }
    _loadingTrackObserverSubscriptions.clear();
  }

  static DownloadTrackInfoStatusTileState _selectStateBasedOnLoadingObserver(
      TrackWithLoadingObserver trackWithLoadingObserver) {
    if (trackWithLoadingObserver.loadingObserver == null) {
      if (trackWithLoadingObserver.track.isLoaded) {
        return const DownloadTrackInfoStatusTileLoaded();
      } else {
        return const DownloadTrackInfoStatusTileDeffault();
      }
    } else {
      switch (trackWithLoadingObserver.loadingObserver!.status) {
        case LoadingTrackStatus.waitInLoadingQueue:
          return const DownloadTrackInfoStatusTileLoading(percent: null);
        case LoadingTrackStatus.loading:
          return DownloadTrackInfoStatusTileLoading(percent: trackWithLoadingObserver.loadingObserver!.loadingPercent);
        case LoadingTrackStatus.loaded:
          return const DownloadTrackInfoStatusTileLoaded();
        case LoadingTrackStatus.loadingCancelled:
          return const DownloadTrackInfoStatusTileDeffault();
        case LoadingTrackStatus.failure:
          return DownloadTrackInfoStatusTileFailure(failure: trackWithLoadingObserver.loadingObserver!.failure);
      }
    }
  }
}
