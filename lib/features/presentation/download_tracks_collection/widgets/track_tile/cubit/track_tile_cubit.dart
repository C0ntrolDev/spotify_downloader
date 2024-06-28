import 'dart:async';

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/entities.dart';

part 'track_tile_state.dart';

class TrackTileCubit extends Cubit<TrackTileState> {
  TrackWithLoadingObserver? _trackWithLoadingObserver;

  StreamSubscription? _loadingObserverSubscription;
  StreamSubscription? _loadingObserverChangedSubscription;

  TrackTileCubit() : super(TrackTileDeffault());

  Future<void> changeTrackWithLoadingObserver(TrackWithLoadingObserver trackWithLoadingObserver) async {
    _trackWithLoadingObserver = trackWithLoadingObserver;

    _loadingObserverChangedSubscription?.cancel();
    _loadingObserverChangedSubscription =
        _trackWithLoadingObserver?.onLoadingTrackObserverChangedStream.listen(_onLoadingObserverChanged);

    _onLoadingObserverChanged(trackWithLoadingObserver.loadingObserver);
  }

  void _onLoadingObserverChanged(LoadingTrackObserver? newLoadingObserver) {
    _unsubscribeFromLoadingObserver();
    _subscribeToLoadingObserver(newLoadingObserver);
    _onLoadingObserverEvent();
  }

  void _unsubscribeFromLoadingObserver() {
    _loadingObserverSubscription?.cancel();
    _loadingObserverSubscription = null;
  }

  void _subscribeToLoadingObserver(LoadingTrackObserver? loadingTrackObserver) {
    if (loadingTrackObserver == null) return;
    _loadingObserverSubscription = StreamGroup.merge([
      loadingTrackObserver.startLoadingStream,
      loadingTrackObserver.loadingPercentChangedStream,
      loadingTrackObserver.loadedStream,
      loadingTrackObserver.loadingFailureStream,
      loadingTrackObserver.loadingCancelledStream
    ]).listen((event) => _onLoadingObserverEvent());
  }

  void _onLoadingObserverEvent() {
    if (_trackWithLoadingObserver == null) return;

    final status = _trackWithLoadingObserver!.loadingObserver?.status;
    if (status == null) {
      if (_trackWithLoadingObserver!.track.isLoaded) {
        emit(TrackTileLoaded());
      } else {
        emit(TrackTileDeffault());
      }

      return;
    }

    if (status == LoadingTrackStatus.loading || status == LoadingTrackStatus.waitInLoadingQueue) {
      emit(TrackTileLoading(percent: _trackWithLoadingObserver!.loadingObserver!.loadingPercent));
      return;
    }

    if (status == LoadingTrackStatus.failure) {
      emit(TrackTileFailure());
      return;
    }

    if (status == LoadingTrackStatus.loadingCancelled) {
      emit(TrackTileDeffault());
      return;
    }

    if (status == LoadingTrackStatus.loaded) {
      emit(TrackTileLoaded());
    }
  }
}
