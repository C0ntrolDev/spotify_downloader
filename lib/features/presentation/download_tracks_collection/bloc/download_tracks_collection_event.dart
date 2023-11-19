part of 'download_tracks_collection_bloc.dart';

sealed class DownloadTracksCollectionBlocEvent extends Equatable {
  const DownloadTracksCollectionBlocEvent();

  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionLoadWithHistoryTracksColleciton extends DownloadTracksCollectionBlocEvent {
  const DownloadTracksCollectionLoadWithHistoryTracksColleciton({required this.historyTracksCollection});

  final HistoryTracksCollection historyTracksCollection;

  @override
  List<Object> get props => [historyTracksCollection];
}

final class DownloadTracksCollectionLoadWithTracksCollecitonUrl extends DownloadTracksCollectionBlocEvent {
  const DownloadTracksCollectionLoadWithTracksCollecitonUrl({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

final class DownloadTracksCollectionUpdateTracks extends DownloadTracksCollectionBlocEvent {
  const DownloadTracksCollectionUpdateTracks({required this.tracks});

  final List<Track> tracks;

  @override
  List<Object> get props => [tracks];
}
