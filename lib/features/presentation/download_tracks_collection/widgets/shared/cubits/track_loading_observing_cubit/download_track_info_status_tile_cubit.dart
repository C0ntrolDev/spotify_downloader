import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';

part 'download_track_info_status_tile_state.dart';

class TrackLoadingObservingCubit extends Cubit<TrackLoadingObservingState> {
  TrackWithLoadingObserver? _trackWithLoadingObserver;

  StreamSubscription? _loadingObserverSubscription;
  StreamSubscription? _loadingObserverChangedSubscription;
  bool _isLoadedIfLoadingObserverIsNull = false;

  TrackLoadingObservingCubit() : super(const TrackLoadingObservingDefault());

  Future<void> changeTrackWithLoadingObserver(TrackWithLoadingObserver trackWithLoadingObserver) async {
    _trackWithLoadingObserver = trackWithLoadingObserver;

    _loadingObserverChangedSubscription?.cancel();
    _loadingObserverChangedSubscription =
        _trackWithLoadingObserver?.onLoadingTrackObserverChangedStream.listen(_onLoadingObserverChanged);

    _onLoadingObserverChanged(trackWithLoadingObserver.loadingObserver);
  }

  void changeIsLoadedIfLoadingObserverIsNull(bool isLoadedByDefault) {
    _isLoadedIfLoadingObserverIsNull = isLoadedByDefault;
    _onLoadingTrackStatusChanged();
  }

  void _onLoadingObserverChanged(LoadingTrackObserver? newLoadingObserver) {
    _unsubscribeFromLoadingObserver();
    _subscribeToLoadingObserver(newLoadingObserver);
    _onLoadingTrackStatusChanged();
  }

  void _unsubscribeFromLoadingObserver() {
    _loadingObserverSubscription?.cancel();
    _loadingObserverSubscription = null;
  }

  void _subscribeToLoadingObserver(LoadingTrackObserver? loadingTrackObserver) {
    if (loadingTrackObserver == null) return;
    _loadingObserverSubscription =
        loadingTrackObserver.loadingTrackStatusStream.listen((event) => _onLoadingTrackStatusChanged());
  }

  void _onLoadingTrackStatusChanged() {
    if (_trackWithLoadingObserver == null) return;

    final status = _trackWithLoadingObserver!.loadingObserver?.status;
    if (status == null) {
      if (_isLoadedIfLoadingObserverIsNull) {
        emit(const TrackLoadingObservingLoaded());
      } else {
        emit(const TrackLoadingObservingDefault());
      }

      return;
    }

    if (status == LoadingTrackStatus.loading || status == LoadingTrackStatus.waitInLoadingQueue) {
      emit(TrackLoadingObservingLoading(percent: _trackWithLoadingObserver!.loadingObserver!.loadingPercent));
      return;
    }

    if (status == LoadingTrackStatus.failure) {
      emit(TrackLoadingObservingFailure(failure: _trackWithLoadingObserver!.loadingObserver!.failure));
      return;
    }

    if (status == LoadingTrackStatus.loadingCancelled) {
      emit(const TrackLoadingObservingDefault());
      return;
    }

    if (status == LoadingTrackStatus.loaded) {
      emit(const TrackLoadingObservingLoaded());
    }
  }
}
