import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/download_tracks_settings.dart';

abstract class DownloadTracksSettingsRepository {
  Future<Result<Failure, DownloadTracksSettings>> getDownloadTracksSettings();
  Future<Result<Failure, void>> saveDownloadTracksSettings(DownloadTracksSettings downloadTracksSettings);
}