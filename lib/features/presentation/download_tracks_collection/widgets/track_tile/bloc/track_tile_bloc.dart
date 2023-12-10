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
        super(TrackTileDeffault(trackWithLoadingObserver.track)) {
    _trackWithLoadingObserver.onTrackObserverChanged = onLoadingTrackObserverChanged;

    on<TrackTileCancelTrackLoading>((event, emit) {
      _cancelTrackLoading.call(_trackWithLoadingObserver.track);
    });

    on<TrackTitleDownloadTrack>((event, emit) async {
     //emit(TrackTileOnTrackLoading(_trackWithLoadingObserver.track));
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

  void onLoadingTrackObserverChanged(LoadingTrackObserver? loadingTrackObserver) {
    if (loadingTrackObserver != null) {
      selectStateBasedOnLoadingTrackObserver(loadingTrackObserver);

      loadingTrackObserver.onStartLoading = () {
        add(const TrackTileLoadingPercentChanged());
      };
      loadingTrackObserver.onLoadingPercentChanged =
          (percent) => add(TrackTileLoadingPercentChanged(loadingPercent: percent));
      loadingTrackObserver.onLoaded = (savePath) => add(TrackTileTrackLoaded());
      loadingTrackObserver.onFailure = (failure) => add(TrackTileTrackLoadingFailure(failure));
      loadingTrackObserver.onLoadingCancelled = () => add(TrackTileSetToDeffaultState());
    } else {
      if (_trackWithLoadingObserver.track.isLoaded) {
        add(TrackTileTrackLoaded());
      }
      else {
        add(TrackTileSetToDeffaultState());
      }
    }
  }

  void selectStateBasedOnLoadingTrackObserver(LoadingTrackObserver loadingTrackObserver) {
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
