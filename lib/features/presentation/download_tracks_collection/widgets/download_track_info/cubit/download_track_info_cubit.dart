import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/entities/loading_track_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/services.dart';

part 'download_track_info_state.dart';

class DownloadTrackInfoCubit extends Cubit<DownloadTrackInfoState> {
  final CancelTrackLoading _cancelTrackLoading;

  DownloadTrackInfoCubit({required CancelTrackLoading cancelTrackLoading})
      : _cancelTrackLoading = cancelTrackLoading,
        super(DownloadTrackInfoDefault());

  void changeTrackYoutubeUrl({required TrackWithLoadingObserver trackWithLoadingObserver, required String newYoutubeUrl}) {
    if (trackWithLoadingObserver.track.youtubeUrl == newYoutubeUrl) return;

    trackWithLoadingObserver.track.isLoaded = false;
    trackWithLoadingObserver.track.youtubeUrl = newYoutubeUrl;

    if (trackWithLoadingObserver.loadingObserver != null &&
        (trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.waitInLoadingQueue ||
            trackWithLoadingObserver.loadingObserver!.status == LoadingTrackStatus.loading)) {
      _cancelTrackLoading.call(trackWithLoadingObserver.track);
    } else {
      trackWithLoadingObserver.loadingObserver = null;
      return;
    }
  }
}
