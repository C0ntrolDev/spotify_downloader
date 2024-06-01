import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';

abstract class LanguageSettingsRepository {
  Future<Result<Failure, String>> getLanguage();

  Future<Result<Failure, void>> saveLanguage(String language);

  Future<Result<Failure, List<String>>> getAvailableLanguage();
}
