import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';

class SaveDownloadTracksSettings implements UseCase<Failure, void, DownloadTracksSettings> {
  SaveDownloadTracksSettings({required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  @override
  Future<Result<Failure, void>> call(DownloadTracksSettings downloadTracksSettings) async {
    return _downloadTracksSettingsRepository.saveDownloadTracksSettings(downloadTracksSettings);
  }
}
