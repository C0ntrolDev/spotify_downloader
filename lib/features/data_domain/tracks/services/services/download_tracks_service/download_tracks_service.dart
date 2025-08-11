import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/service_loading_tracks_statuses_observer.dart';

abstract class DownloadTracksService {
  Future<Result<Failure, void>> preselectYouTubeUrl(Track track, String preselectedYouTubeUrl);
  Future<Result<Failure, void>> downloadTrack(Track track);
  Future<Result<Failure , void>> cancelTrackLoading(Track track);
  Future<Result<Failure, ServiceLoadingTracksStatusesObserver>> observeTracksDownloadStatuses(TracksCollection tracksCollection);
  Future<Result<Failure, void>> removeTracksDownloadStatusesObserver(ServiceLoadingTracksStatusesObserver observer);
}
