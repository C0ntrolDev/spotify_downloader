import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/download_track.dart';

part 'download_track_info_event.dart';
part 'download_track_info_state.dart';

class DownloadTrackInfoBloc extends Bloc<DownloadTrackInfoEvent, DownloadTrackInfoState> {
  final CancelTrackLoading _cancelTrackLoading;
  final DownloadTrack _downloadTrack;

  final TrackWithLoadingObserver _trackWithLoadingObserver;

  DownloadTrackInfoBloc(
      {required TrackWithLoadingObserver trackWithLoadingObserver,
      required CancelTrackLoading cancelTrackLoading,
      required DownloadTrack downloadTrack})
      : _trackWithLoadingObserver = trackWithLoadingObserver,
        _cancelTrackLoading = cancelTrackLoading,
        _downloadTrack = downloadTrack,
        super(DownloadTrackInfoLoaded(trackWithLoadingObserver: trackWithLoadingObserver)) {
          
    on<DownloadTrackInfoChangeYoutubeUrl>((event, emit) async {
      if (_trackWithLoadingObserver.loadingObserver != null &&
              _trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.waitInLoadingQueue ||
          _trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loading) {
        await _cancelTrackLoading.call(_trackWithLoadingObserver.track);
        final downloadTrackResult = await _downloadTrack.call(_trackWithLoadingObserver.track);
        if (downloadTrackResult.isSuccessful) {
          _trackWithLoadingObserver.loadingObserver = downloadTrackResult.result;
        } else {
          emit(DownloadTrackInfoFailure(
              failure: downloadTrackResult.failure, trackWithLoadingObserver: _trackWithLoadingObserver));
        }
      }
    });
  }
}
