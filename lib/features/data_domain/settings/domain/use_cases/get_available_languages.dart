import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/language_settings_repository.dart';

class GetAvailableLanguages implements UseCase<Failure, List<String>, void> {
  GetAvailableLanguages({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;
      
  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, List<String>>> call(void params) async {
    return _languageSettingsRepository.getAvailableLanguage();
  }
}