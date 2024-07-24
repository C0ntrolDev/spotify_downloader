part of 'get_tracks_bloc.dart';

sealed class GetTracksState extends Equatable {
  const GetTracksState();

  @override
  List<Object?> get props => [];
}

final class GetTracksInitial extends GetTracksState {}

sealed class GetTracksTracksGot extends GetTracksState {
  const GetTracksTracksGot({required this.tracksWithLoadingObservers})
      : _initialTracksLength = tracksWithLoadingObservers.length;

  final List<TrackWithLoadingObserver> tracksWithLoadingObservers;
  final int _initialTracksLength;

  @override
  List<Object?> get props => [tracksWithLoadingObservers, _initialTracksLength];
}

final class GetTracksPartGot extends GetTracksTracksGot {
  const GetTracksPartGot({required super.tracksWithLoadingObservers});
}

final class GetTracksAllGot extends GetTracksTracksGot {
  const GetTracksAllGot({required super.tracksWithLoadingObservers});
}

final class GetTracksTracksGettingStarted extends GetTracksState {
  const GetTracksTracksGettingStarted({required this.observer});

  final TracksWithLoadingObserverGettingObserver observer;

  @override
  List<Object?> get props => [observer];
}

final class GetTracksTracksGettingCountinued extends GetTracksTracksGot {
  const GetTracksTracksGettingCountinued({required super.tracksWithLoadingObservers, required this.observer});

  final TracksWithLoadingObserverGettingObserver observer;

  @override
  List<Object?> get props => super.props..add(observer);
}

final class GetTracksAfterPartGotNetworkFailure extends GetTracksTracksGot {
  const GetTracksAfterPartGotNetworkFailure({required super.tracksWithLoadingObservers});
}

final class GetTracksBeforePartGotNetworkFailure extends GetTracksState {}

final class GetTracksFatalFailure extends GetTracksState {
  const GetTracksFatalFailure({required this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}