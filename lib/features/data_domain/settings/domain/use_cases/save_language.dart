import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/core/utils/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/language_settings_repository.dart';


class SaveLanguage implements UseCase<Failure, void, String> {
  SaveLanguage({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;

  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, void>> call(String language) async {
    return _languageSettingsRepository.saveLanguage(language);
  }
}
