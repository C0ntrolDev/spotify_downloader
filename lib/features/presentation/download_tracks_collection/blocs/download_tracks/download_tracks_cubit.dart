import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

part 'download_tracks_state.dart';

class DownloadTracksCubit extends Cubit<DownloadTracksState> {
  final DownloadTracksRange _downloadTracksRange;
  final DownloadTracksFromGettingObserver _downloadTracksFromGettingObserver;
  final DownloadTrack _downloadTrack;
  final CancelTrackLoading _cancelTrackLoading;

  TracksWithLoadingObserverGettingObserver? _gettingObserver;
  List<TrackWithLoadingObserver>? _trackList;
  final Map<TrackWithLoadingObserver, String> _preselectedTracksYouTubeUrls = {};
  bool _isAllTracksGot = false;

  bool _isAllTracksDownloadStarted = false;

  DownloadTracksCubit(
      {required DownloadTracksRange downloadTracksRange,
      required DownloadTracksFromGettingObserver downloadTracksFromGettingObserver,
      required DownloadTrack downloadTrack,
      required CancelTrackLoading cancelTrackLoading})
      : _downloadTracksRange = downloadTracksRange,
        _downloadTracksFromGettingObserver = downloadTracksFromGettingObserver,
        _downloadTrack = downloadTrack,
        _cancelTrackLoading = cancelTrackLoading,
        super(const DownloadTracksDefault(preselectedTracksYouTubeUrls: {}));

  Future<void> downloadAllTracks() async {
    if (_trackList != null && _trackList!.isNotEmpty) {
      final downloadTracksRangeResult = await _downloadTracksRange.call((_trackList!, _preselectedTracksYouTubeUrls));
      if (!downloadTracksRangeResult.isSuccessful) {
        emit(DownloadTracksFailure(
            failure: downloadTracksRangeResult.failure, preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
        return;
      }
    }

    _isAllTracksDownloadStarted = true;

    if (_gettingObserver != null && !_isAllTracksGot) {
      final downloadTracksFromGettingObserverResult = await _downloadTracksFromGettingObserver.call(_gettingObserver!);
      if (!downloadTracksFromGettingObserverResult.isSuccessful) {
        emit(DownloadTracksFailure(
            failure: downloadTracksFromGettingObserverResult.failure,
            preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
        return;
      }
    }
  }

  Future<void> downloadTracksRange(List<TrackWithLoadingObserver> tracksRange) async {
    final downloadTracksRangeResult = await _downloadTracksRange.call((tracksRange, _preselectedTracksYouTubeUrls));
    if (!downloadTracksRangeResult.isSuccessful) {
      emit(DownloadTracksFailure(
          failure: downloadTracksRangeResult.failure, preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
      return;
    }
  }

  Future<void> continueAllTracksDownloadIfNeed() async {
    if (_isAllTracksDownloadStarted) {
      if (_gettingObserver != null && !_isAllTracksGot) {
        final downloadTracksFromGettingObserverResult =
            await _downloadTracksFromGettingObserver.call(_gettingObserver!);
        if (!downloadTracksFromGettingObserverResult.isSuccessful) {
          emit(DownloadTracksFailure(
              failure: downloadTracksFromGettingObserverResult.failure,
              preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
          return;
        }
      }
    }
  }

  Future<void> downloadTrack(TrackWithLoadingObserver trackWithLoadingObserver) async {
    final downloadTrackResult =
        await _downloadTrack.call((trackWithLoadingObserver, _preselectedTracksYouTubeUrls[trackWithLoadingObserver]));
    if (!downloadTrackResult.isSuccessful) {
      emit(DownloadTracksFailure(
          failure: downloadTrackResult.failure, preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
      return;
    }
  }

  Future<void> cancelTrackLoading(TrackWithLoadingObserver trackWithLoadingObserver) async {
    final canceltrackLoading = await _cancelTrackLoading.call(trackWithLoadingObserver);
    if (!canceltrackLoading.isSuccessful && canceltrackLoading.failure is! NotFoundFailure) {
      emit(DownloadTracksFailure(
          failure: canceltrackLoading.failure, preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
      return;
    }
  }

  void changeTrackYoutubeUrl(TrackWithLoadingObserver trackWithLoadingObserver, String newYoutubeUrl) {
    final oldUrl = _preselectedTracksYouTubeUrls[trackWithLoadingObserver];
    if (oldUrl == newYoutubeUrl) return;

    _preselectedTracksYouTubeUrls[trackWithLoadingObserver] = newYoutubeUrl;

    cancelTrackLoading(trackWithLoadingObserver);
    emit(DownloadTracksDefault(preselectedTracksYouTubeUrls: _preselectedTracksYouTubeUrls));
  }

  void setGettingObserver(TracksWithLoadingObserverGettingObserver? gettingObserver) {
    _gettingObserver = gettingObserver;
  }

  void setTracksList(List<TrackWithLoadingObserver>? tracksList) {
    _trackList = tracksList;
  }

  void setIsAllTracksGot(bool isAllTracksGot) {
    _isAllTracksGot = isAllTracksGot;
  }
}
