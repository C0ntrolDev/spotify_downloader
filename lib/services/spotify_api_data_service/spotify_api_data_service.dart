import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/infrastructure/exceptions/account_not_authorized_exception.dart';

class SpotifyApiDataService {

  SpotifyApiDataService({
    required this.clientId,
    required this.clientSecret,
    this.accessToken
  });

  AccessTokenResponse? accessToken;

  String clientId;
  String clientSecret;

  Future<Track> getTrackByUrl(String id) async {
    var spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(clientId, clientSecret));
    spotify.
  }

  Future<Playlist> getPlaylistByUrl(String url) async {
    SpotifyApi.
  }

  Future<Album> getAlbumByUrl(String url) async {
  }

  Future<List<Track>> getLikedTracks() async {
    if (accessToken == null) {
      throw AccountNotAuthorizedException(cause: 'spotify account not authorize');
    }
  }

  String getIdFromUrl(String url) {
    final stringWithoutUrlAdress = url.split('/').last;
    final id = stringWithoutUrlAdress.split('?').first;
    return id;
  }


}