part of 'download_tracks_collection_bloc.dart';

sealed class DownloadTracksCollectionBlocState extends Equatable {
  const DownloadTracksCollectionBlocState();

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionInitial extends DownloadTracksCollectionBlocState {}

final class DownloadTracksCollectionPartLoaded extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionPartLoaded({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object> get props => [tracksCollection];
}

final class DownloadTracksCollectionAllLoaded extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionAllLoaded({required this.tracksCollection});

  final TracksCollection tracksCollection;

  @override
  List<Object> get props => [tracksCollection];
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
