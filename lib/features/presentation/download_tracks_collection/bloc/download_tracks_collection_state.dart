part of 'download_tracks_collection_bloc.dart';

sealed class DownloadTracksCollectionBlocState extends Equatable {
  const DownloadTracksCollectionBlocState();

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionInitialLoading extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

abstract class DownloadTracksCollectionOnTracksGot extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionOnTracksGot({required this.tracksCollection, required this.tracks, required this.displayingTracksCount});

  final int displayingTracksCount;
  final TracksCollection tracksCollection;
  final List<TrackWithLoadingObserver> tracks;

  @override
  List<Object> get props => [tracksCollection, tracks];
}

final class DownloadTracksCollectionOnTracksPartGot extends DownloadTracksCollectionOnTracksGot {
  const DownloadTracksCollectionOnTracksPartGot({required super.tracksCollection, required super.tracks, required super.displayingTracksCount});
}

final class DownloadTracksCollectionOnAllTracksGot extends DownloadTracksCollectionOnTracksGot {
  const DownloadTracksCollectionOnAllTracksGot({required super.tracksCollection, required super.tracks, required super.displayingTracksCount});
}

final class DownloadTracksCollectionAfterInititalNoInternetConnection  extends DownloadTracksCollectionOnTracksGot {
  const DownloadTracksCollectionAfterInititalNoInternetConnection({required super.tracksCollection, required super.tracks, required super.displayingTracksCount});
}

final class DownloadTracksCollectionBeforeInitialNoInternetConnection extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionFailure extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}