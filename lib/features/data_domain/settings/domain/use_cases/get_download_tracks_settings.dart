import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';

class GetDownloadTracksSettings implements UseCase<Failure, DownloadTracksSettings, void> {
  GetDownloadTracksSettings({required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _downloadTracksSettingsRepository = downloadTracksSettingsRepository;

  final DownloadTracksSettingsRepository _downloadTracksSettingsRepository;

  @override
  Future<Result<Failure, DownloadTracksSettings>> call(void params) async {
    return _downloadTracksSettingsRepository.getDownloadTracksSettings();
  }
}
