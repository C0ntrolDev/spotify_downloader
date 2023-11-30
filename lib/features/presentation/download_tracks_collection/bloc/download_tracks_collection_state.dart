part of 'download_tracks_collection_bloc.dart';

sealed class DownloadTracksCollectionBlocState extends Equatable {
  const DownloadTracksCollectionBlocState();

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionLoading extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

abstract class DownloadTracksCollectionTracksGetted extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionTracksGetted({required this.tracksCollection, required this.tracks});

  final TracksCollection tracksCollection;
  final List<TrackWithLoadingObserver> tracks;

  @override
  List<Object> get props => [tracksCollection, tracks];
}

final class DownloadTracksCollectionOnTracksPartGetted extends DownloadTracksCollectionTracksGetted {
  const DownloadTracksCollectionOnTracksPartGetted({required super.tracksCollection, required super.tracks});
}

final class DownloadTracksCollectionAllTracksGetted extends DownloadTracksCollectionTracksGetted {
  const DownloadTracksCollectionAllTracksGetted({required super.tracksCollection, required super.tracks});
}

final class DownloadTracksCollectionInitialNetworkFailure extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionTracksGettingNetworkFailure extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionTracksGettingNetworkFailure({required this.tracksCollection});

  final TracksCollection tracksCollection;
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionFailure extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

final class DownloadTracksCollectionTracksGettingCancelled extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}
