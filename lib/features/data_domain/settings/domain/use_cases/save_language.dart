import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';

class SaveLanguage implements UseCase<Failure, void, String> {
  SaveLanguage({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;

  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, void>> call(String language) async {
    return _languageSettingsRepository.saveLanguage(language);
  }
}
