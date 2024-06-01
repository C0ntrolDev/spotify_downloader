import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/services/use_cases/download_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

part 'track_tile_event.dart';
part 'track_tile_state.dart';

class TrackTileBloc extends Bloc<TrackTileEvent, TrackTileState> {
  final DownloadTrack _dowloadTrack;
  final CancelTrackLoading _cancelTrackLoading;
  final TrackWithLoadingObserver _trackWithLoadingObserver;

  late final StreamSubscription<LoadingTrackObserver?>? _onLoadingObserverChangedSubscription;
  final List<StreamController> _subscribedStreamControllers = List.empty(growable: true);

  TrackTileBloc({
    required TrackWithLoadingObserver trackWithLoadingObserver,
    required DownloadTrack downloadTrack,
    required CancelTrackLoading cancelTrackLoading,
  })  : _cancelTrackLoading = cancelTrackLoading,
        _trackWithLoadingObserver = trackWithLoadingObserver,
        _dowloadTrack = downloadTrack,
        super(selectStateBasedOnTrackWithLoadingObserver(trackWithLoadingObserver)) {
    _onLoadingObserverChangedSubscription =
        trackWithLoadingObserver.onLoadingTrackObserverChangedStream.listen((loadingObserver) {
      add(TrackTileLoadingObserverChanged(loadingObserver));
    });

    on<TrackTileCancelTrackLoading>((event, emit) {
      _cancelTrackLoading.call(_trackWithLoadingObserver.track);
    });

    on<TrackTitleDownloadTrack>(_onDownloadTrack);

    on<TrackTileLoadingObserverChanged>(_onLoadingTrackObserverChanged);
    
    add(TrackTileLoadingObserverChanged(_trackWithLoadingObserver.loadingObserver));
  }

  @override
  Future<void> close() async {
    await unsubscribeFromLoadingTrackObserver();
    await _onLoadingObserverChangedSubscription?.cancel();
    await super.close();
  }

  static TrackTileState selectStateBasedOnTrackWithLoadingObserver(TrackWithLoadingObserver trackWithLoadingObserver) {
    if (trackWithLoadingObserver.loadingObserver != null) {
      switch (trackWithLoadingObserver.loadingObserver!.status) {
        case LoadingTrackStatus.waitInLoadingQueue:
          return TrackTileTrackLoading(trackWithLoadingObserver);
        case LoadingTrackStatus.loading:
          return TrackTileTrackLoading(trackWithLoadingObserver,
              percent: trackWithLoadingObserver.loadingObserver!.loadingPercent);
        case LoadingTrackStatus.loaded:
          return TrackTileTrackLoaded(trackWithLoadingObserver);
        case LoadingTrackStatus.loadingCancelled:
          return TrackTileDeffault(trackWithLoadingObserver);
        case LoadingTrackStatus.failure:
          return TrackTileTrackFailure(trackWithLoadingObserver,
              failure: trackWithLoadingObserver.loadingObserver?.failure);
      }
    }

    if (trackWithLoadingObserver.track.isLoaded) {
      return TrackTileTrackLoaded(trackWithLoadingObserver);
    } else {
      return TrackTileDeffault(trackWithLoadingObserver);
    }
  }

  Future<void> _onDownloadTrack(TrackTitleDownloadTrack event, Emitter<TrackTileState> emit) async {
    final loadingObserverResult = await _dowloadTrack.call(_trackWithLoadingObserver.track);
    if (loadingObserverResult.isSuccessful) {
      _trackWithLoadingObserver.loadingObserver = loadingObserverResult.result;
    } else {
      emit(TrackTileTrackFailure(_trackWithLoadingObserver, failure: loadingObserverResult.failure));
    }
  }

  Future<void> _onLoadingTrackObserverChanged(
      TrackTileLoadingObserverChanged event, Emitter<TrackTileState> emit) async {
    if (event.loadingTrackObserver != null) {
      await unsubscribeFromLoadingTrackObserver();
      emit(selectStateBasedOnTrackWithLoadingObserver(_trackWithLoadingObserver));
      await subscribeToLoadingTrackObserver(event.loadingTrackObserver!, emit);
    } else {
      if (_trackWithLoadingObserver.track.isLoaded) {
        emit(TrackTileTrackLoaded(_trackWithLoadingObserver));
      } else {
        emit(TrackTileDeffault(_trackWithLoadingObserver));
      }
    }
  }

  Future<void> subscribeToLoadingTrackObserver(
      LoadingTrackObserver loadingTrackObserver, Emitter<TrackTileState> emit) async {
    await Future.wait([
      emit.forEach(_subscribeToStream(loadingTrackObserver.startLoadingStream),
          onData: (string) => TrackTileTrackLoading(_trackWithLoadingObserver, percent: null)),
      emit.forEach(_subscribeToStream(loadingTrackObserver.loadingPercentChangedStream),
          onData: (percent) => TrackTileTrackLoading(_trackWithLoadingObserver, percent: percent)),
      emit.forEach(_subscribeToStream(loadingTrackObserver.loadedStream),
          onData: (savePath) => TrackTileTrackLoaded(_trackWithLoadingObserver)),
      emit.forEach(_subscribeToStream(loadingTrackObserver.loadingFailureStream),
          onData: (failure) => TrackTileTrackFailure(_trackWithLoadingObserver, failure: failure)),
      emit.forEach(_subscribeToStream(loadingTrackObserver.loadingCancelledStream),
          onData: (_) => TrackTileDeffault(_trackWithLoadingObserver))
    ]);
  }

  Stream<T> _subscribeToStream<T>(Stream<T> stream) {
    final subscribedStreamController = StreamController<T>();
    final streamSub = stream.listen((event) {
      subscribedStreamController.add(event);
    });
    subscribedStreamController.onCancel = () => streamSub.cancel();
    _subscribedStreamControllers.add(subscribedStreamController);
    return subscribedStreamController.stream;
  }

  Future<void> unsubscribeFromLoadingTrackObserver() async {
    for (var subscription in _subscribedStreamControllers) {
      await subscription.close();
    }
  }
}
