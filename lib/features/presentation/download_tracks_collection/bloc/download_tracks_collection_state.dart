part of 'download_tracks_collection_bloc.dart';

sealed class DownloadTracksCollectionBlocState extends Equatable {
  const DownloadTracksCollectionBlocState();

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionInitial extends DownloadTracksCollectionBlocState {}

final class DownloadTracksCollectionLoaded extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionLoaded({required this.tracksCollection, required this.tracks});

  final TracksCollection tracksCollection;
  final List<Track> tracks;

  @override
  List<Object> get props => [tracksCollection, tracks];
}

final class DownloadTracksCollectionNetworkFailure extends DownloadTracksCollectionBlocState {

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionNotFoundFailure extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionFailure extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
