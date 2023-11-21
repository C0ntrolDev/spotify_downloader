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

abstract class DownloadTracksCollectionLoaded extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionLoaded(this.tracks, {required this.tracksCollection});

  final TracksCollection tracksCollection;
  final List<Track> tracks;

  @override
  List<Object> get props => [tracksCollection, tracks];
}

final class DownloadTracksCollectionPartLoaded extends DownloadTracksCollectionLoaded {
  const DownloadTracksCollectionPartLoaded(super.tracks, {required super.tracksCollection});
}

final class DownloadTracksCollectionAllLoaded extends DownloadTracksCollectionLoaded {
  const DownloadTracksCollectionAllLoaded(super.tracks, {required super.tracksCollection});
}

final class DownloadTracksCollectionNetworkFailure extends DownloadTracksCollectionBlocState {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionFailure extends DownloadTracksCollectionBlocState {
  const DownloadTracksCollectionFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
