import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/domain/tracks/services/use_cases/cancel_track_loading.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';

part 'download_track_info_event.dart';
part 'download_track_info_state.dart';

class DownloadTrackInfoBloc extends Bloc<DownloadTrackInfoEvent, DownloadTrackInfoState> {
  final CancelTrackLoading _cancelTrackLoading;
  final TrackWithLoadingObserver _trackWithLoadingObserver;

  DownloadTrackInfoBloc(
      {required TrackWithLoadingObserver trackWithLoadingObserver, required CancelTrackLoading cancelTrackLoading})
      : _trackWithLoadingObserver = trackWithLoadingObserver,
        _cancelTrackLoading = cancelTrackLoading,
        super(DownloadTrackInfoLoaded(trackWithLoadingObserver: trackWithLoadingObserver)) {
    on<DownloadTrackInfoChangeYoutubeUrl>((event, emit) async {
      if (trackWithLoadingObserver.track.youtubeUrl == event.youtubeUrl) return;

      _trackWithLoadingObserver.track.isLoaded = false;
      _trackWithLoadingObserver.track.youtubeUrl = event.youtubeUrl;

      if (_trackWithLoadingObserver.loadingObserver != null &&
          (_trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.waitInLoadingQueue ||
              _trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loading)) {
        await _cancelTrackLoading.call(_trackWithLoadingObserver.track);
      } else {
        _trackWithLoadingObserver.loadingObserver = null;
        return;
      }
    });
  }
}
