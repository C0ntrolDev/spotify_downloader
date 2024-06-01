import 'dart:io';

import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:spotify_downloader/core/consts/spotify_client.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';

import 'package:spotify_downloader/features/data_domain/auth/data/network_auth/models/auth_response.dart';


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

      if (accessTokenResponse.accessToken == null ||
          accessTokenResponse.refreshToken == null ||
          accessTokenResponse.expirationDate == null) {
        return Result.notSuccessful(AuthFailure(message: 'the received token does not match the required parameters'));
      }

      return Result.isSuccessful(AuthResponse(
          accessToken: accessTokenResponse.accessToken!,
          refreshToken: accessTokenResponse.refreshToken!,
          expiration: accessTokenResponse.expirationDate!));
    } on SocketException catch (e) {
      return Result.notSuccessful(NetworkFailure(message: e));
    }
  }
}
