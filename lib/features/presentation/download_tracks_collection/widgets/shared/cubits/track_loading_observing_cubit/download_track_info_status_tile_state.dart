part of 'download_track_info_status_tile_cubit.dart';

sealed class TrackLoadingObservingState extends Equatable {
  const TrackLoadingObservingState();

  @override
  List<Object?> get props => [];
}

final class TrackLoadingObservingDeffault extends TrackLoadingObservingState {
  const TrackLoadingObservingDeffault();
}

final class TrackLoadingObservingLoading extends TrackLoadingObservingState {
  const TrackLoadingObservingLoading({required this.percent});

  final double? percent;

  @override
  List<Object?> get props => [percent];
}

final class TrackLoadingObservingLoaded extends TrackLoadingObservingState {
  const TrackLoadingObservingLoaded();
}

final class TrackLoadingObservingFailure extends TrackLoadingObservingState {
  const TrackLoadingObservingFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}
