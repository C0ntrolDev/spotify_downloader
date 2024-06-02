import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

abstract class DownloadTracksRepository {
  Future<Result<Failure, LoadingTrackObserver>> dowloadTrack(TrackWithLazyYoutubeUrl lazyTrack, String savePath);
  Result<Failure, void> cancelTrackLoading(Track track, String savePat);
  Future<Result<Failure, LoadingTrackObserver?>> getLoadingTrackObserver(Track track, String savePath);
}
