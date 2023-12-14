part of 'track_tile_bloc.dart';

sealed class TrackTileState extends Equatable {
  const TrackTileState(this.trackWithLoadingObserver);

  final TrackWithLoadingObserver trackWithLoadingObserver;
  Track get track => trackWithLoadingObserver.track;

  @override
  List<Object?> get props => [];
}

final class TrackTileDeffault extends TrackTileState {
  const TrackTileDeffault(super.trackWithLoadingObserver);
}

final class TrackTileOnTrackLoading extends TrackTileState {
  final double? percent;

  const TrackTileOnTrackLoading(super.trackWithLoadingObserver, {this.percent});

  @override
  List<Object?> get props => [track, percent];
}

final class TrackTileOnTrackLoaded extends TrackTileState {
  const TrackTileOnTrackLoaded(super.trackWithLoadingObserver);
}

final class TrackTileTrackOnFailure extends TrackTileState {
  final Failure? failure;

  const TrackTileTrackOnFailure(super.trackWithLoadingObserver, {this.failure});

  @override
  List<Object?> get props => [track, failure];
}
