import 'dart:async';
import 'loading_tracks_collection_info.dart';

class LoadingTracksCollectionObserver {
  LoadingTracksCollectionObserver(
      {required this.changedStream,
      required this.allLoadedStream,
      required LoadingTracksCollectionInfo Function() getLoadingInfo})
      : _getLoadingInfo = getLoadingInfo {
    allLoadedStream.listen((event) {
      _lastAllLoadedTime = DateTime.now();
    });
  }

  final Stream<void> changedStream;
  final Stream<void> allLoadedStream;

  final LoadingTracksCollectionInfo Function() _getLoadingInfo;

  LoadingTracksCollectionInfo get loadingInfo => _getLoadingInfo.call();

  DateTime? _lastAllLoadedTime;
  DateTime? get lastAllLoadedTime => _lastAllLoadedTime;
}
