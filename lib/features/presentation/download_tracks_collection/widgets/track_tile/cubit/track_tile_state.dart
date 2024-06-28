part of 'track_tile_cubit.dart';

sealed class TrackTileState extends Equatable {
  const TrackTileState();

  @override
  List<Object?> get props => [];
}

final class TrackTileDeffault extends TrackTileState {}

final class TrackTileFailure extends TrackTileState {}

final class TrackTileLoading extends TrackTileState {
  const TrackTileLoading({required this.percent});

  final double? percent;

  @override
  List<Object?> get props => [percent];
}

final class TrackTileLoaded extends TrackTileState {}
