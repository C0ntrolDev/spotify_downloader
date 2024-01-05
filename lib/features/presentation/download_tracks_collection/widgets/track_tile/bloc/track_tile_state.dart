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

final class TrackTileTrackLoading extends TrackTileState {
  final double? percent;

  const TrackTileTrackLoading(super.trackWithLoadingObserver, {this.percent});

  @override
  List<Object?> get props => [track, percent];
}

final class TrackTileTrackLoaded extends TrackTileState {
  const TrackTileTrackLoaded(super.trackWithLoadingObserver);
}

final class TrackTileTrackFailure extends TrackTileState {
  final Failure? failure;

  const TrackTileTrackFailure(super.trackWithLoadingObserver, {this.failure});

  @override
  List<Object?> get props => [track, failure];
}
