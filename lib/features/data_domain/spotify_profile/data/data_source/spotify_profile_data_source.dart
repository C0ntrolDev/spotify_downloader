import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/spotify_api_request.dart';

class SpotifyProfileDataSource {
  Future<Result<Failure, User>> getSpotifyProfile(SpotifyApiRequest spotifyApiRequest) async {
    final profileResult = handleSpotifyClientExceptions(() async {
      final spotifyClient = await SpotifyApi.asyncFromCredentials(spotifyApiRequest.spotifyApiCredentials,
          onCredentialsRefreshed: spotifyApiRequest.onCredentialsRefreshed);
      final profile = await spotifyClient.me.get();
      return Result.isSuccessful(profile);
    });

    return profileResult;
  }
}
