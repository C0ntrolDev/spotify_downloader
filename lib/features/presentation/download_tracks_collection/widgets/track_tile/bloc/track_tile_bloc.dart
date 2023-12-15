import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_track.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

part 'track_tile_event.dart';
part 'track_tile_state.dart';

class TrackTileBloc extends Bloc<TrackTileEvent, TrackTileState> {
  final DownloadTrack _dowloadTrack;
  final CancelTrackLoading _cancelTrackLoading;
  final TrackWithLoadingObserver _trackWithLoadingObserver;

  StreamSubscription<LoadingTrackObserver?>? loadingTrackObserverChangedSubscription;

  TrackTileBloc({
    required TrackWithLoadingObserver trackWithLoadingObserver,
    required DownloadTrack downloadTrack,
    required CancelTrackLoading cancelTrackLoading,
  })  : _cancelTrackLoading = cancelTrackLoading,
        _trackWithLoadingObserver = trackWithLoadingObserver,
        _dowloadTrack = downloadTrack,
        super(returnStateBasedOnTrackWithLoadingObserver(trackWithLoadingObserver)) {
    loadingTrackObserverChangedSubscription = _trackWithLoadingObserver.onLoadingTrackObserverChangedStream.listen(onLoadingTrackObserverChanged);

    on<TrackTileCancelTrackLoading>((event, emit) {
      _cancelTrackLoading.call(_trackWithLoadingObserver.track);
    });

    on<TrackTitleDownloadTrack>((event, emit) async {
      final loadingObserverResult = await _dowloadTrack.call(_trackWithLoadingObserver.track);
      if (loadingObserverResult.isSuccessful) {
        _trackWithLoadingObserver.loadingObserver = loadingObserverResult.result;
      } else {
        emit(TrackTileTrackOnFailure(_trackWithLoadingObserver, failure: loadingObserverResult.failure));
      }
    });

    on<TrackTileSetToDeffaultState>((event, emit) {
      emit(TrackTileDeffault(_trackWithLoadingObserver));
    });

    on<TrackTileLoadingPercentChanged>((event, emit) {
      emit(TrackTileOnTrackLoading(_trackWithLoadingObserver, percent: event.loadingPercent));
    });

    on<TrackTileTrackLoaded>((event, emit) {
      emit(TrackTileOnTrackLoaded(_trackWithLoadingObserver));
    });

    on<TrackTileTrackLoadingFailure>((event, emit) {
      emit(TrackTileTrackOnFailure(_trackWithLoadingObserver, failure: event.failure));
    });

    onLoadingTrackObserverChanged(_trackWithLoadingObserver.loadingObserver);
  }

  @override
  Future<void> close() async {
    await loadingTrackObserverChangedSubscription?.cancel();
    await super.close();
    return;
  }


  static TrackTileState returnStateBasedOnTrackWithLoadingObserver(TrackWithLoadingObserver trackWithLoadingObserver) {
    if (trackWithLoadingObserver.loadingObserver != null) {
      switch (trackWithLoadingObserver.loadingObserver!.status) {
        case LoadingTrackStatus.waitInLoadingQueue:
          return TrackTileOnTrackLoading(trackWithLoadingObserver);
        case LoadingTrackStatus.loading:
          return TrackTileOnTrackLoading(trackWithLoadingObserver,
              percent: trackWithLoadingObserver.loadingObserver!.loadingPercent);
        case LoadingTrackStatus.loaded:
          return TrackTileOnTrackLoaded(trackWithLoadingObserver);
        case LoadingTrackStatus.loadingCancelled:
          return TrackTileDeffault(trackWithLoadingObserver);
        case LoadingTrackStatus.failure:
          return TrackTileTrackOnFailure(trackWithLoadingObserver,
              failure: trackWithLoadingObserver.loadingObserver?.failure);
      }
    }

    if (trackWithLoadingObserver.track.isLoaded) {
      return TrackTileOnTrackLoaded(trackWithLoadingObserver);
    } else {
      return TrackTileDeffault(trackWithLoadingObserver);
    }
  }

  void onLoadingTrackObserverChanged(LoadingTrackObserver? loadingTrackObserver) {
    if (loadingTrackObserver != null) {
      addEventBasedOnLoadingTrackObserver(loadingTrackObserver);

      loadingTrackObserver.startLoadingStream.listen((youtubeUrl) => add(const TrackTileLoadingPercentChanged()));
      loadingTrackObserver.loadingPercentChangedStream
          .listen((percent) => add(TrackTileLoadingPercentChanged(loadingPercent: percent)));
      loadingTrackObserver.loadedStream.listen((savePath) => add(TrackTileTrackLoaded()));
      loadingTrackObserver.loadingFailureStream.listen((failure) => add(TrackTileTrackLoadingFailure(failure)));
      loadingTrackObserver.loadingCancelledStream.listen((event) => add(TrackTileSetToDeffaultState()));
    } else {
      if (_trackWithLoadingObserver.track.isLoaded) {
        add(TrackTileTrackLoaded());
      } else {
        add(TrackTileSetToDeffaultState());
      }
    }
  }

  void addEventBasedOnLoadingTrackObserver(LoadingTrackObserver loadingTrackObserver) {
    switch (loadingTrackObserver.status) {
      case LoadingTrackStatus.waitInLoadingQueue:
        add(const TrackTileLoadingPercentChanged());
      case LoadingTrackStatus.loading:
        add(TrackTileLoadingPercentChanged(loadingPercent: loadingTrackObserver.loadingPercent));
      case LoadingTrackStatus.loaded:
        add(TrackTileTrackLoaded());
      case LoadingTrackStatus.loadingCancelled:
        add(TrackTileSetToDeffaultState());
      case LoadingTrackStatus.failure:
        add(TrackTileTrackLoadingFailure(loadingTrackObserver.failure));
    }
  }
}
