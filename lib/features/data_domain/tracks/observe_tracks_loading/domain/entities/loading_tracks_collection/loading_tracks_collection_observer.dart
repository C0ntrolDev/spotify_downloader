import 'dart:async';

import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection.dart';

class LoadingTracksCollectionObserver {
  LoadingTracksCollectionObserver(
      {required this.changedStream,
      required this.allLoadedStream,
      required this.loadingStatusChangedStream,
      required LoadingTracksCollectionInfo Function() getLoadingInfo,
      required LoadingTracksCollectionStatus Function() getLoadingStatus})
      : _getLoadingInfo = getLoadingInfo,
      _getLoadingStatus = getLoadingStatus;

  final Stream<void> changedStream;
  final Stream<void> allLoadedStream;
  final Stream<void> loadingStatusChangedStream;

  final LoadingTracksCollectionInfo Function() _getLoadingInfo;
  LoadingTracksCollectionInfo get loadingInfo => _getLoadingInfo.call();

  final LoadingTracksCollectionStatus Function() _getLoadingStatus;
  LoadingTracksCollectionStatus get loadingStatus => _getLoadingStatus.call();
}
