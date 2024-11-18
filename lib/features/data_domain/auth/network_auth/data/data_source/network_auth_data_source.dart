import 'dart:io';

import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/network_auth/data/data.dart';

class NetworkAuthDataSource {
  Future<Result<Failure, AuthResponse>> authorizeUser(String clientId) async {
    try {
      final client = SpotifyOAuth2Client(
          redirectUri: 'com.cdev.spotifydownloader://callback', customUriScheme: 'com.cdev.spotifydownloader');
      final accessTokenResponse = await client.getTokenWithAuthCodeFlow(
          clientId: clientId,
          scopes: clientScopes);

      if (accessTokenResponse.error != null) {
        return Result.notSuccessful(
            AuthFailure(message: '${accessTokenResponse.error} : ${accessTokenResponse.errorDescription}'));
      }

      if(accessTokenResponse.httpStatusCode == 404) {
        return Result.notSuccessful(AuthExitFailure());
      }

      if (accessTokenResponse.accessToken == null ||
          accessTokenResponse.refreshToken == null ||
          accessTokenResponse.expirationDate == null) {
        return Result.notSuccessful(AuthFailure(message: 'the received token does not match the required parameters'));
      }

      return Result.isSuccessful(AuthResponse(
          accessToken: accessTokenResponse.accessToken!,
          refreshToken: accessTokenResponse.refreshToken!,
          expiration: accessTokenResponse.expirationDate!));
    } on SocketException catch (e, s) {
      return Result.notSuccessful(NetworkFailure(message: e, stackTrace: s));
    }
  }
}
