import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/consts/local_paths.dart';
import 'package:spotify_downloader/features/data_domain/auth/data/local_auth/models/local_auth_credentials.dart';

class LocalAuthDataSource {
  Future<LocalAuthCredentials?> getLocalAuthCredentials() async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteAuthFilePath = '$localDirectoryPath$authSettingPath';

    final authFile = File(absoluteAuthFilePath);
    if (await authFile.exists()) {
      final json = await authFile.readAsString();
      return _localAuthCredentialsFromJson(json);
    }

    return null;
  }

  Future<void> saveLocalAuthCredentials(LocalAuthCredentials localAuthCredentials) async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteAuthFilePath = '$localDirectoryPath$authSettingPath';

    final authFile = File(absoluteAuthFilePath);
    await authFile.writeAsString(_localAuthCredentialsToJson(localAuthCredentials));
  }

  String _localAuthCredentialsToJson(LocalAuthCredentials localAuthCredentials) {
    return jsonEncode({
      'clientId': localAuthCredentials.clientId,
      'clientSecret': localAuthCredentials.clientSecret,
      'refreshToken': localAuthCredentials.refreshToken,
      'accessToken': localAuthCredentials.accessToken,
      'expiration': localAuthCredentials.expirationInMillisecondsSinceEpoch
    });
  }

  LocalAuthCredentials? _localAuthCredentialsFromJson(String jsonData) {
    final decodedData = jsonDecode(jsonData);
    return LocalAuthCredentials(
        clientId: decodedData['clientId'],
        clientSecret: decodedData['clientSecret'],
        refreshToken: decodedData['refreshToken'],
        accessToken: decodedData['accessToken'],
        expirationInMillisecondsSinceEpoch: decodedData['expiration']);
  }
}
