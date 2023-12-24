import 'dart:async';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_status.dart';

import 'loading_tracks_collection_info.dart';

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
