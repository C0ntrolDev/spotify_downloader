part of 'get_and_download_tracks_bloc.dart';

sealed class GetAndDownloadTracksState extends Equatable {
  const GetAndDownloadTracksState();

  @override
  List<Object?> get props => [];
}

final class GetAndDownloadTracksInitital extends GetAndDownloadTracksState {}

final class GetAndDownloadTracksTracksGetting extends GetAndDownloadTracksState {}

sealed class GetAndDownloadTracksTracksGot extends GetAndDownloadTracksState {
  const GetAndDownloadTracksTracksGot({required this.tracksWithLoadingObservers})
      : _initialTracksLength = tracksWithLoadingObservers.length;

  final List<TrackWithLoadingObserver> tracksWithLoadingObservers;
  final int _initialTracksLength;

  @override
  List<Object?> get props => [tracksWithLoadingObservers, _initialTracksLength];
}

final class GetAndDownloadTracksPartGot extends GetAndDownloadTracksTracksGot {
  const GetAndDownloadTracksPartGot({required super.tracksWithLoadingObservers});
}

final class GetAndDownloadTracksAllGot extends GetAndDownloadTracksTracksGot {
  const GetAndDownloadTracksAllGot({required super.tracksWithLoadingObservers});
}

final class GetAndDownloadTracksAfterPartGotNetworkFailure extends GetAndDownloadTracksTracksGot {
  const GetAndDownloadTracksAfterPartGotNetworkFailure({required super.tracksWithLoadingObservers});
}

final class GetAndDownloadTracksBeforePartGotNetworkFailure extends GetAndDownloadTracksState {}

final class GetAndDownloadTracksFailure extends GetAndDownloadTracksState {
  const GetAndDownloadTracksFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}
