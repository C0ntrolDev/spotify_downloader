import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

part 'download_tracks_state.dart';

class DownloadTracksCubit extends Cubit<DownloadTracksState> {
  final DownloadTracksRange _downloadTracksRange;
  final DownloadTracksFromGettingObserver _downloadTracksFromGettingObserver;
  final DownloadTrack _downloadTrack;

  TracksWithLoadingObserverGettingObserver? _gettingObserver;
  List<TrackWithLoadingObserver>? _trackList;
  bool _isAllTracksGot = false;

  DownloadTracksCubit(
      {required DownloadTracksRange downloadTracksRange,
      required DownloadTracksFromGettingObserver downloadTracksFromGettingObserver,
      required DownloadTrack downloadTrack})
      : _downloadTracksRange = downloadTracksRange,
        _downloadTracksFromGettingObserver = downloadTracksFromGettingObserver,
        _downloadTrack = downloadTrack,
        super(DownloadTracksInitial());

  Future<void> downloadAllTracks() async {
    if (_trackList != null && _trackList!.isNotEmpty) {
      final downloadTracksRangeResult = await _downloadTracksRange.call(_trackList!);
      if (!downloadTracksRangeResult.isSuccessful) {
        emit(DownloadTracksFailure(failure: downloadTracksRangeResult.failure));
        return;
      }
    }

    if (_gettingObserver != null && !_isAllTracksGot) {
      final downloadTracksFromGettingObserverResult = await _downloadTracksFromGettingObserver.call(_gettingObserver!);
      if (!downloadTracksFromGettingObserverResult.isSuccessful) {
        emit(DownloadTracksFailure(failure: downloadTracksFromGettingObserverResult.failure));
        return;
      }
    }
  }

  Future<void> downloadTracksRange(List<TrackWithLoadingObserver> tracksRange) async {
    final downloadTracksRangeResult = await _downloadTracksRange.call(tracksRange);
    if (!downloadTracksRangeResult.isSuccessful) {
      emit(DownloadTracksFailure(failure: downloadTracksRangeResult.failure));
      return;
    }
  }

  Future<void> downloadTrack(TrackWithLoadingObserver trackWithLoadingObserver) async {
    final downloadTrackResult = await _downloadTrack.call(trackWithLoadingObserver.track);
    if (!downloadTrackResult.isSuccessful) {
      emit(DownloadTracksFailure(failure: downloadTrackResult.failure));
      return;
    }

    trackWithLoadingObserver.loadingObserver = downloadTrackResult.result;
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
