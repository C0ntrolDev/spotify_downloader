part of 'download_track_info_status_tile_cubit.dart';

sealed class DownloadTrackInfoStatusTileState extends Equatable {
  const DownloadTrackInfoStatusTileState();

  @override
  List<Object?> get props => [];
}

final class DownloadTrackInfoStatusTileDeffault extends DownloadTrackInfoStatusTileState {
  const DownloadTrackInfoStatusTileDeffault();
}

final class DownloadTrackInfoStatusTileLoading extends DownloadTrackInfoStatusTileState {
  const DownloadTrackInfoStatusTileLoading({required this.percent});

  final double? percent;

  @override
  List<Object?> get props => [percent];
}

final class DownloadTrackInfoStatusTileLoaded extends DownloadTrackInfoStatusTileState {
  const DownloadTrackInfoStatusTileLoaded();
}

final class DownloadTrackInfoStatusTileFailure extends DownloadTrackInfoStatusTileState {
  const DownloadTrackInfoStatusTileFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}
