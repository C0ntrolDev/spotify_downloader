part of 'track_tile_bloc.dart';

sealed class TrackTileEvent extends Equatable {
  const TrackTileEvent();

  @override
  List<Object?> get props => [];
}

final class TrackTitleDownloadTrack extends TrackTileEvent {}

final class TrackTileCancelTrackLoading extends TrackTileEvent {}

final class TrackTileLoadingPercentChanged extends TrackTileEvent {
  const TrackTileLoadingPercentChanged({this.loadingPercent});
  final double? loadingPercent;

  @override
  List<Object?> get props => [loadingPercent];
}

final class TrackTileSetToDeffaultState extends TrackTileEvent {}

final class TrackTileTrackLoaded extends TrackTileEvent {
  const TrackTileTrackLoaded(this.savePath);

  final String? savePath;

  @override
  List<Object?> get props => [savePath];
}

final class TrackTileTrackLoadingFailure extends TrackTileEvent {
  const TrackTileTrackLoadingFailure(this.failure);

  final Failure? failure;
}
