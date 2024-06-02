import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/enitities.dart';

abstract class DownloadTracksSettingsRepository {
  Future<Result<Failure, DownloadTracksSettings>> getDownloadTracksSettings();
  Future<Result<Failure, void>> saveDownloadTracksSettings(DownloadTracksSettings downloadTracksSettings);
}