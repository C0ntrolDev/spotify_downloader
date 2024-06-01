import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/download_tracks_settings.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';
class GetDownloadTracksSettings implements UseCase<Failure, DownloadTracksSettings, void> {
  GetDownloadTracksSettings({required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  @override
  Future<Result<Failure, DownloadTracksSettings>> call(void params) async {
    return _downloadTracksSettingsRepository.getDownloadTracksSettings();
  }
}
