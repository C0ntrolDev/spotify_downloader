import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/consts/local_paths.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/settings/data/models/app_settings.dart';

class SettingsDataSource {
  Future<void> saveSettings(AppSettings appSettings) async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteAuthFilePath = '$localDirectoryPath$settingsPath';

    final authFile = File(absoluteAuthFilePath);
    await authFile.writeAsString(_appSettingsToJson(appSettings));
  }

  Future<Result<Failure, AppSettings?>> getSettings() async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteAuthFilePath = '$localDirectoryPath$settingsPath';

    final authFile = File(absoluteAuthFilePath);
    if (await authFile.exists()) {
      final json = await authFile.readAsString();
      return _appSettingsFromJson(json);
    }

    return const Result.isSuccessful(null);
  }

  String _appSettingsToJson(AppSettings appSettings) {
    return jsonEncode(
        {'saveMode': appSettings.saveMode, 'savePath': appSettings.savePath, 'language': appSettings.language});
  }

  Result<Failure, AppSettings?> _appSettingsFromJson(String jsonData) {
    final decodedData = jsonDecode(jsonData);
    try {
      return Result.isSuccessful(AppSettings(
          saveMode: decodedData['saveMode'], savePath: decodedData['savePath'], language: decodedData['language']));
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}
