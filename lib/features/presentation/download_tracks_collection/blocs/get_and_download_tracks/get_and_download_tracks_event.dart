part of 'get_and_download_tracks_bloc.dart';

sealed class GetAndDownloadTracksEvent extends Equatable {
  const GetAndDownloadTracksEvent();

  @override
  List<Object?> get props => [];
}

final class GetAndDownloadTracksSubscribeToConnectivity extends GetAndDownloadTracksEvent {}

final class GetAndDownloadTracksGetTracks extends GetAndDownloadTracksEvent {
  const GetAndDownloadTracksGetTracks({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object?> get props => [tracksCollection];
}

final class GetAndDownloadTracksContinueTracksGetting extends GetAndDownloadTracksEvent {}

final class GetAndDownloadTracksDownloadAllTracks extends GetAndDownloadTracksEvent {}

final class GetAndDownloadTracksDownloadTracksRange extends GetAndDownloadTracksEvent {
  final List<TrackWithLoadingObserver> tracksRange;

  const GetAndDownloadTracksDownloadTracksRange({required this.tracksRange});

  @override
  List<Object?> get props => [tracksRange];
}
