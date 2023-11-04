import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';

class SpotifyLocalCredentialsService {

  final String _spotifyCredentialsJsonPath = '/account_info.json';

  Future<SpotifyApiCredentials?> loadSpotifyApiCredentials() async {

    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;

    if(await File('$localDirectoryPath$_spotifyCredentialsJsonPath').exists() == false){
      return null;
    }
    final file = File('$localDirectoryPath$_spotifyCredentialsJsonPath'); 
    final response = await file.readAsString();
    final decodedResponse = json.decode(response);
    final spotifyCredentials = _spotifyCredentialsFromMap(decodedResponse as Map<String, dynamic>);
    
    return spotifyCredentials;
  }

  Future<void> saveSpotifyApiCredentials(SpotifyApiCredentials spotifyCredentials) async {
    final spotifyCredentialsMap = _spotifyCredentialsToMap(spotifyCredentials);
    final spotifyCredentialsJson = json.encode(spotifyCredentialsMap);

    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final file = File('$localDirectoryPath$_spotifyCredentialsJsonPath');
    await file.writeAsString(spotifyCredentialsJson, mode: FileMode.writeOnly);
  }

  Future<void> deleteSpotifyApiCredentials() async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final file = File('$localDirectoryPath$_spotifyCredentialsJsonPath');
    await file.delete();
  }

  Map<String,dynamic> _spotifyCredentialsToMap(SpotifyApiCredentials spotifyCredentials) {
    return {
      'accessToken': spotifyCredentials.accessToken,
      'refreshToken': spotifyCredentials.refreshToken,
      'clientId': spotifyCredentials.clientId,
      'clientSecret': spotifyCredentials.clientSecret,
      'scopes': spotifyCredentials.scopes, 
      'expiration' : spotifyCredentials.expiration?.millisecondsSinceEpoch
    };
  }

  SpotifyApiCredentials _spotifyCredentialsFromMap(Map<String, dynamic> mappedSpotifyCredentials) {
    return SpotifyApiCredentials(
      mappedSpotifyCredentials['clientId'] as String,
      mappedSpotifyCredentials['clientSecret'] as String,
      accessToken: mappedSpotifyCredentials['accessToken'] as String,
      refreshToken: mappedSpotifyCredentials['refreshToken'] as String,
      scopes: (mappedSpotifyCredentials['scopes'] as List<dynamic>).map((e) => e as String).toList(),
      expiration: DateTime.fromMillisecondsSinceEpoch(mappedSpotifyCredentials['expiration'] as int)
      );
  }
}
