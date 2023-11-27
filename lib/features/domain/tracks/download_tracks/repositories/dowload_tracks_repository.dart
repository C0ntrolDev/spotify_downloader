// ignore_for_file: void_checks

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/download_tracks/entities/loading_track_observer.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

abstract class DowloadTracksRepository {
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(Track track);
  Result<Failure, void> cancelTrackLoading(Track track);
  Future<Result<Failure, LoadingTrackObserver?>> getLoadingTrackObserver(Track track);
  Future<Result<Failure, void>> removeLoadingTrackObserver(LoadingTrackObserver loadingTrackObserver);
}
