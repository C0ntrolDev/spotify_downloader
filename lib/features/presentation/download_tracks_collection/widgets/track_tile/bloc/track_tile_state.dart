part of 'track_tile_bloc.dart';

sealed class TrackTileState extends Equatable {
  const TrackTileState(this.track);

  final Track track;

  @override
  List<Object?> get props => [];
}

final class TrackTileDeffault extends TrackTileState {
  const TrackTileDeffault(super.track);
}

final class TrackTileTrackLoading extends TrackTileState {
  final double? percent;

  const TrackTileTrackLoading(super.track, {this.percent});

  @override
  List<Object?> get props => [track, percent];
}

final class TrackTileOnTrackLoaded extends TrackTileState {
  const TrackTileOnTrackLoaded(super.track);
}

final class TrackTileTrackOnFailure extends TrackTileState {
  final Failure? failure;

  const TrackTileTrackOnFailure(super.track, {this.failure});

  @override
  List<Object?> get props => [track, failure];
}
