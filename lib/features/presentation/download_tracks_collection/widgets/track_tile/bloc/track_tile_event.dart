part of 'track_tile_bloc.dart';

sealed class TrackTileEvent extends Equatable {
  const TrackTileEvent();

  @override
  List<Object?> get props => [];
}

final class TrackTitleDownloadTrack extends TrackTileEvent {}

final class TrackTileCancelTrackLoading extends TrackTileEvent {}

final class TrackTileLoadingObserverChanged extends TrackTileEvent {
  const TrackTileLoadingObserverChanged(this.loadingTrackObserver);

  final LoadingTrackObserver? loadingTrackObserver;

  @override
  List<Object?> get props => [loadingTrackObserver];
}
