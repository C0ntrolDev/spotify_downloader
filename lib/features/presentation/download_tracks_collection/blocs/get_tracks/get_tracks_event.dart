part of 'get_tracks_bloc.dart';

sealed class GetTracksEvent extends Equatable {
  const GetTracksEvent();

  @override
  List<Object?> get props => [];
}

final class GetTracksGetTracks extends GetTracksEvent {
  const GetTracksGetTracks({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object?> get props => [tracksCollection];
}

class _GetTracksGettingObserverPartGot extends GetTracksEvent {
  const _GetTracksGettingObserverPartGot({required this.part});

  final List<TrackWithLoadingObserver> part;

  @override
  List<Object?> get props => [part];
}

class _GetTracksGettingObserverEnd extends GetTracksEvent {
  const _GetTracksGettingObserverEnd({required this.gettingResult});

  final Result<Failure, TracksGettingEndedStatus> gettingResult;

  @override
  List<Object?> get props => [gettingResult];
}

class _GetTracksSubscribeToConnectivity extends GetTracksEvent {
  @override
  List<Object?> get props => [];
}

class _GetTracksConnectionChanged extends GetTracksEvent {
  const _GetTracksConnectionChanged({required this.connection});

  final ConnectivityResult connection;

  @override
  List<Object?> get props => [];
}

class _GetTracksContinueTracksGetting extends GetTracksEvent {}