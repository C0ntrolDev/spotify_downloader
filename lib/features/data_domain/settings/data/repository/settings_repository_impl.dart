import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/settings.dart';

class SettingsRepositoryImpl implements DownloadTracksSettingsRepository, LanguageSettingsRepository {
  SettingsRepositoryImpl({required SettingsDataSource settingsDataSource}) : _settingsDataSource = settingsDataSource;

  final SettingsDataSource _settingsDataSource;
  AppSettings? _currentSettings;

  @override
  Future<Result<Failure, DownloadTracksSettings>> getDownloadTracksSettings() async {
    final getSettingsResult = await _getSettings();
    if (!getSettingsResult.isSuccessful) {
      return Result.notSuccessful(getSettingsResult.failure);
    }

    return Result.isSuccessful(DownloadTracksSettings(
        savePath: _currentSettings!.savePath, saveMode: SaveMode.values[_currentSettings!.saveMode]));
  }

  @override
  Future<Result<Failure, void>> saveDownloadTracksSettings(DownloadTracksSettings downloadTracksSettings) async {
    final getSettingsResult = await _getSettings();
    if (!getSettingsResult.isSuccessful) {
      return Result.notSuccessful(getSettingsResult.failure);
    }

    final newSettings = AppSettings(
        savePath: downloadTracksSettings.savePath,
        saveMode: downloadTracksSettings.saveMode.index,
        language: getSettingsResult.result!.language);
    return _saveSettings(newSettings);
  }

  @override
  Future<Result<Failure, String>> getLanguage() async {
    final getSettingsResult = await _getSettings();
    if (!getSettingsResult.isSuccessful) {
      return Result.notSuccessful(getSettingsResult.failure);
    }

    return Result.isSuccessful(getSettingsResult.result!.language);
  }

  @override
  Future<Result<Failure, void>> saveLanguage(String language) async {
    final getSettingsResult = await _getSettings();
    if (!getSettingsResult.isSuccessful) {
      return Result.notSuccessful(getSettingsResult.failure);
    }

    final newSettings = AppSettings(
        savePath: getSettingsResult.result!.savePath,
        saveMode: getSettingsResult.result!.saveMode,
        language: language);
    return _saveSettings(newSettings);
  }

  Future<Result<Failure, AppSettings>> _getSettings() async {
    if (_currentSettings != null) {
      return Result.isSuccessful(_currentSettings);
    }

    final getSettingsResult = await _settingsDataSource.getSettings();
    if (!getSettingsResult.isSuccessful) {
      return Result.notSuccessful(getSettingsResult.failure);
    }

    if (getSettingsResult.result != null) {
      _currentSettings = getSettingsResult.result;
      return Result.isSuccessful(_currentSettings!);
    }

    final getDefaultSettingsResult = await _settingsDataSource.getDefaultAppSettings();
    if (!getDefaultSettingsResult.isSuccessful) {
      return Result.notSuccessful(getDefaultSettingsResult.failure);
    }

    _currentSettings = getDefaultSettingsResult.result!;
    return Result.isSuccessful(getDefaultSettingsResult.result!);
  }

  Future<Result<Failure, void>> _saveSettings(AppSettings newSettings) async {
    _currentSettings = newSettings;
    return _settingsDataSource.saveSettings(newSettings);
  }

  @override
  Future<Result<Failure, List<String>>> getAvailableLanguage() async {
    return Result.isSuccessful(_settingsDataSource.getAvailableLanguages());
  }
}
