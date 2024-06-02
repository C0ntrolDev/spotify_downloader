import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/domain.dart';

class GetLanguage implements UseCase<Failure, String, void> {
  GetLanguage({required LanguageSettingsRepository languageSettingsRepository})
      : _languageSettingsRepository = languageSettingsRepository;
      
  final LanguageSettingsRepository _languageSettingsRepository;

  @override
  Future<Result<Failure, String>> call(void params) async {
    return _languageSettingsRepository.getLanguage();
  }
}
