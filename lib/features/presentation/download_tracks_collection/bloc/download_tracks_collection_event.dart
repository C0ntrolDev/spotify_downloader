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

final class DownloadTracksCollectionTracksPartGot extends DownloadTracksCollectionBlocEvent {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionTracksGettingEnded extends DownloadTracksCollectionBlocEvent {
  const DownloadTracksCollectionTracksGettingEnded({required this.result});

  final Result<Failure, TracksGettingEndedStatus> result;

  @override
  List<Object> get props => [result];
}

final class DownloadTracksCollectionCancelTracksGetting extends DownloadTracksCollectionBlocEvent {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionContinueTracksGetting extends DownloadTracksCollectionBlocEvent {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionInternetConnectionGoneAfterInitial extends DownloadTracksCollectionBlocEvent {
  @override
  List<Object> get props => [];
}

final class DownloadTracksCollectionInternetConnectionGoneBeforeInitial extends DownloadTracksCollectionBlocEvent {
  @override
  List<Object> get props => [];
}