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

  TrackTileBloc({
    required TrackWithLoadingObserver trackWithLoadingObserver,
    required DownloadTrack dowloadTrack,
    required CancelTrackLoading cancelTrackLoading,
  })  : _cancelTrackLoading = cancelTrackLoading,
        _trackWithLoadingObserver = trackWithLoadingObserver,
        _dowloadTrack = dowloadTrack,
        super(returnStateBasedOnTrackWithLoadingObserver(trackWithLoadingObserver)) {
    _trackWithLoadingObserver.onTrackObserverChanged = onLoadingTrackObserverChanged;

    on<TrackTileCancelTrackLoading>((event, emit) {
      _cancelTrackLoading.call(_trackWithLoadingObserver.track);
    });

    on<TrackTitleDownloadTrack>((event, emit) async {
      final loadingObserverResult = await _dowloadTrack.call(_trackWithLoadingObserver.track);
      if (loadingObserverResult.isSuccessful) {
        _trackWithLoadingObserver.loadingObserver = loadingObserverResult.result;
      } else {
        emit(TrackTileTrackOnFailure(_trackWithLoadingObserver.track, failure: loadingObserverResult.failure));
      }
    });

    on<TrackTileSetToDeffaultState>((event, emit) {
      emit(TrackTileDeffault(_trackWithLoadingObserver.track));
    });

    on<TrackTileLoadingPercentChanged>((event, emit) {
      emit(TrackTileOnTrackLoading(_trackWithLoadingObserver.track, percent: event.loadingPercent));
    });

    on<TrackTileTrackLoaded>((event, emit) {
      emit(TrackTileOnTrackLoaded(_trackWithLoadingObserver.track));
    });

    on<TrackTileTrackLoadingFailure>((event, emit) {
      emit(TrackTileTrackOnFailure(_trackWithLoadingObserver.track, failure: event.failure));
    });

    onLoadingTrackObserverChanged(_trackWithLoadingObserver.loadingObserver);
  }

  static TrackTileState returnStateBasedOnTrackWithLoadingObserver(TrackWithLoadingObserver trackWithLoadingObserver) {
    if (trackWithLoadingObserver.loadingObserver != null) {
      switch (trackWithLoadingObserver.loadingObserver!.status) {
        case LoadingTrackStatus.waitInLoadingQueue:
          return TrackTileOnTrackLoading(trackWithLoadingObserver.track);
        case LoadingTrackStatus.loading:
          return TrackTileOnTrackLoading(trackWithLoadingObserver.track,
              percent: trackWithLoadingObserver.loadingObserver!.loadingPercent);
        case LoadingTrackStatus.loaded:
          return TrackTileOnTrackLoaded(trackWithLoadingObserver.track);
        case LoadingTrackStatus.loadingCancelled:
          return TrackTileDeffault(trackWithLoadingObserver.track);
        case LoadingTrackStatus.failure:
          return TrackTileTrackOnFailure(trackWithLoadingObserver.track,
              failure: trackWithLoadingObserver.loadingObserver?.failure);
      }
    }

    if (trackWithLoadingObserver.track.isLoaded) {
      return TrackTileOnTrackLoaded(trackWithLoadingObserver.track);
    } else {
      return TrackTileDeffault(trackWithLoadingObserver.track);
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
