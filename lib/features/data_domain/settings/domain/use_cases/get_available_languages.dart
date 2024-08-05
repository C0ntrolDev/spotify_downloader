import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/repository.dart';

class GetAvailableLanguages implements UseCase<Failure, List<String>, void> {
  GetAvailableLanguages({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;
      
  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, List<String>>> call(void params) async {
    return _languageSettingsRepository.getAvailableLanguage();
  }
}