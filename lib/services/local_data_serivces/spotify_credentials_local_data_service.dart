import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';

class SpotifyCredentialsLocalDataService {

  final String _spotifyCredentialsJsonPath = '/account_info.json';

  Future<SpotifyApiCredentials?> loadSpotifyApiCredentials() async {

    final localDirectoryPath = (await getApplicationDocumentsDirectory()).absolute;

    if(await File('$localDirectoryPath$_spotifyCredentialsJsonPath').exists() == false){
      return null;
    }

    final response = await rootBundle.loadString('$localDirectoryPath$_spotifyCredentialsJsonPath');
    final spotifyCredentials = _spotifyCredentialsFromMap(response as Map<String, dynamic>);
    
    return spotifyCredentials;
  }

  Future<void> saveSpotifyApiCredentials(SpotifyApiCredentials spotifyCredentials) async {
    final spotifyCredentialsMap = _spotifyCredentialsToMap(spotifyCredentials);
    final spotifyCredentialsJson = json.encode(spotifyCredentialsMap);

    final localDirectoryPath = (await getApplicationDocumentsDirectory()).absolute;
    final file = File('$localDirectoryPath$_spotifyCredentialsJsonPath');
    await file.writeAsString(spotifyCredentialsJson, mode: FileMode.writeOnly);
  }

  Map<String,dynamic> _spotifyCredentialsToMap(SpotifyApiCredentials spotifyCredentials) {
    return {
      'accessToken': spotifyCredentials.accessToken,
      'refreshToken': spotifyCredentials.refreshToken,
      'clientId': spotifyCredentials.clientId,
      'clientSecret': spotifyCredentials.clientSecret,
      'scopes': spotifyCredentials.scopes, 
      'expiration' : spotifyCredentials.expiration
    };
  }

  SpotifyApiCredentials _spotifyCredentialsFromMap(Map<String, dynamic> mappedSpotifyCredentials) {
    return SpotifyApiCredentials(
      mappedSpotifyCredentials['clientId'] as String,
      mappedSpotifyCredentials['clientSecret'] as String,
      accessToken: mappedSpotifyCredentials['accessToken'] as String,
      refreshToken: mappedSpotifyCredentials['refreshToken'] as String,
      scopes: mappedSpotifyCredentials['scopes'] as List<String>,
      expiration: mappedSpotifyCredentials['expirations']
      );
  }
}
