import 'package:spotify_downloader/core/utils/utils.dart';

abstract class LanguageSettingsRepository {
  Future<Result<Failure, String>> getLanguage();

  Future<Result<Failure, void>> saveLanguage(String language);

  Future<Result<Failure, List<String>>> getAvailableLanguage();
}
