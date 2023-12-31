import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';
import 'package:spotify_downloader/features/data/shared/spotify_api_request.dart';

class SpotifyProfileDataSource {
  Future<Result<Failure, User>> getSpotifyProfile(SpotifyApiRequest spotifyApiRequest) async {

    final profileResult = handleSpotifyClientExceptions(() async {
      spotifyApiRequest.spotifyApiCredentials.scopes = [
        'playlist-read-private',
        'user-library-read',
        'user-read-email',
        'user-read-private'
      ];
      spotifyApiRequest.spotifyApiCredentials.expiration = DateTime(2022);
      final spotifyClient = SpotifyApi(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final profile = await spotifyClient.me.get();
      return Result.isSuccessful(profile);
    });

    return profileResult;
  }
}
