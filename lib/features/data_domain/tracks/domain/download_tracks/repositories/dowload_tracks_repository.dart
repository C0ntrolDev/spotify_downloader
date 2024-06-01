// ignore_for_file: void_checks

import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/download_tracks/entities/track_with_lazy_youtube_url.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

abstract class DownloadTracksRepository {
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(TrackWithLazyYoutubeUrl lazyTrack, String savePath);
  Result<Failure, void> cancelTrackLoading(Track track, String savePat);
  Future<Result<Failure, LoadingTrackObserver?>> getLoadingTrackObserver(Track track, String savePath);
}
