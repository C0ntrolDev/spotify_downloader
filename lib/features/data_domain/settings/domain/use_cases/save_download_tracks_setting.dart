import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/download_tracks_settings.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';


class SaveDownloadTracksSettings implements UseCase<Failure, void, DownloadTracksSettings> {
  SaveDownloadTracksSettings({required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  @override
  Future<Result<Failure, void>> call(DownloadTracksSettings downloadTracksSettings) async {
    return _downloadTracksSettingsRepository.saveDownloadTracksSettings(downloadTracksSettings);
  }
}
