import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl_standalone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/consts/local_paths.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/settings/data/data.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class SettingsDataSource {
  Future<Result<Failure, void>> saveSettings(AppSettings appSettings) async {
    try {
      final localDirectoryPath = (await getApplicationSupportDirectory()).path;
      final absoluteAuthFilePath = '$localDirectoryPath$settingsPath';

      final authFile = File(absoluteAuthFilePath);
      await authFile.writeAsString(_appSettingsToJson(appSettings));

      return const Result.isSuccessful(null);
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }

  Future<Result<Failure, AppSettings?>> getSettings() async {
    try {
      final localDirectoryPath = (await getApplicationSupportDirectory()).path;
      final absoluteAuthFilePath = '$localDirectoryPath$settingsPath';

      final authFile = File(absoluteAuthFilePath);
      if (await authFile.exists()) {
        final json = await authFile.readAsString();
        return _appSettingsFromJson(json);
      }

      return const Result.isSuccessful(null);
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }

  Future<Result<Failure, AppSettings>> getDefaultAppSettings() async {
    try {
      String? defaultSavePath;
      if (defaultTargetPlatform == TargetPlatform.android) {
        const downloadsDirectoryPath = "/storage/emulated/0/Download";
        if (await Directory.fromUri(Uri.parse(downloadsDirectoryPath)).exists()) {
          defaultSavePath = "$downloadsDirectoryPath/SpotifyDownloader";
        }
      }

      defaultSavePath ??= "${(await getApplicationDocumentsDirectory()).path}/SpotifyDownloader";

      const defaultSaveMode = 0;

      final availableLanguages = getAvailableLanguages();
      final systemLanguage = await findSystemLocale();

      final defaultLanguage = availableLanguages.contains(systemLanguage) ? systemLanguage : 'en';

      return Result.isSuccessful(
          AppSettings(savePath: defaultSavePath, language: defaultLanguage, saveMode: defaultSaveMode));
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }

  List<String> getAvailableLanguages() {
    return S.delegate.supportedLocales.map((l) => l.languageCode).toList();
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
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }
}
