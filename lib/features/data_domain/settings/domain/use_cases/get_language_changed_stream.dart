import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';

class GetLanguageChangedStream implements UseCase<Failure, Stream<String>, void> {
  GetLanguageChangedStream({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;
      
  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, Stream<String>>> call(void params) async {
    return _languageSettingsRepository.getLanguageChangedStream();
  }
}
