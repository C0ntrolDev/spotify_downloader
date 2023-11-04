import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/infrastructure/exceptions/exceptions.dart';
import 'package:spotify_downloader/services/local_data_serivces/spotify_local_credentials_service.dart';

class SpotifyApiDataService {
  SpotifyApiDataService({
    required String clientId,
    required String clientSecret,
    required SpotifyLocalCredentialsService spotifyLocalCredentialsService,
  })  : _clientId = clientId,
        _clientSecret = clientSecret,
        _spotifyCredentialsLocalDataService = spotifyLocalCredentialsService;

  final SpotifyLocalCredentialsService _spotifyCredentialsLocalDataService;
  final String _clientId;
  final String _clientSecret;

  SpotifyApiCredentials? spotifyCredentials;

  Future<Track?> getTrackByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));

    try {
      final track = await spotify.tracks.get(_getIdFromUrl(url));
      return track;
    } catch (e) {
      return null;
    }
  }

  Future<Playlist?> getPlaylistByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));

    try {
      final playlist = await spotify.playlists.get(_getIdFromUrl(url));
      return playlist;
    } catch (e) {
      return null;
    }
  }

  Future<Playlist?> getAlbumByUrl(String url) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));

    try {
      final album = await spotify.playlists.get(_getIdFromUrl(url));
      return album;
    } catch (e) {
      return null;
    }
  }

  String _getIdFromUrl(String url) {
    final stringWithoutUrlAdress = url.split('/').last;
    final id = stringWithoutUrlAdress.split('?').first;
    return id;
  }

  Future<void> getLikedTracks({
    required List<TrackSaved> saveCollection,
    required Function updateCallback,
    int firstCallbackLength = 750,
    int callbackLength = 50,
  }) async {
    
    if (spotifyCredentials?.accessToken == null) {
      throw AccountNotAuthorizedException(cause: 'spotify account not authorize');
    }

    final spotify = await SpotifyApi.asyncFromCredentials(spotifyCredentials!,
        onCredentialsRefreshed: (newCredentials) =>
            _spotifyCredentialsLocalDataService.saveSpotifyApiCredentials(newCredentials));
    final likedTracksPages = spotify.tracks.me.saved;

    _getCollectionFromPages<TrackSaved>(
        pages: likedTracksPages,
        saveCollection: saveCollection,
        updateCallback: updateCallback,
        firstCallbackLength: firstCallbackLength,
        callbackLength: callbackLength);
  }

  Future<void> getTrackCollectionByPlaylist({
    required Playlist playlist,
    required List<Track> saveCollection,
    required Function updateCallback,
    int firstCallbackLength = 750,
    int callbackLength = 50,
  }) async {
    final spotify = await SpotifyApi.asyncFromCredentials(SpotifyApiCredentials(_clientId, _clientSecret));
    final tracksPages = spotify.playlists.getTracksByPlaylistId(playlist.id);

    await _getCollectionFromPages<Track>(
        pages: tracksPages,
        saveCollection: saveCollection,
        updateCallback: updateCallback,
        firstCallbackLength: firstCallbackLength,
        callbackLength: callbackLength);
  }

  Future<void> _getCollectionFromPages<T>({
    required Pages<T> pages,
    required List<T> saveCollection,
    required Function updateCallback,
    required firstCallbackLength,
    required callbackLength,
  }) async {
    final callbackTracks = List<T>.empty(growable: true);

    var isFirstCallbackInvoked = false;

    await Future(() async {
      for (var i = 0;; i++) {
        final newTracks = (await pages.getPage(50, i * 50)).items;

        if (newTracks == null || newTracks.isEmpty) {
          saveCollection.addAll(callbackTracks);
          updateCallback();
          break;
        }

        callbackTracks.addAll(newTracks);

        if (callbackTracks.length >= (isFirstCallbackInvoked ? callbackLength : firstCallbackLength)) {
          if (isFirstCallbackInvoked == false) {
            isFirstCallbackInvoked = true;
          }

          saveCollection.addAll(callbackTracks);
          updateCallback();
          callbackTracks.clear();
        }
      }
    });
  }

}
