import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';

class LoadingTracksCollectionsObserver {
  LoadingTracksCollectionsObserver(
      {required this.loadingTracksCollectionsChangedStream,
      required List<LoadingTracksCollectionObserver> Function() getLoadingTracksCollections})
      : _getLoadingTracksCollections = getLoadingTracksCollections;

  Stream<void> loadingTracksCollectionsChangedStream;

  final List<LoadingTracksCollectionObserver> Function() _getLoadingTracksCollections;
  List<LoadingTracksCollectionObserver> get loadingTracksCollections => _getLoadingTracksCollections.call();
}