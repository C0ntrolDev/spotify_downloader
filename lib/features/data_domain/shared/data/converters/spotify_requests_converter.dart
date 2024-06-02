import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/converters/spotify_credentials_converter.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/spotify_api_request.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';

class SpotifyRequestsConverter implements ValueConverter<SpotifyApiRequest, SpotifyRepositoryRequest> {
  final SpotifyCredentialsConverter _credentialsConverter = SpotifyCredentialsConverter();

  @override
  SpotifyApiRequest convert(SpotifyRepositoryRequest repositoryRequest) {
    return SpotifyApiRequest(
        spotifyApiCredentials: _credentialsConverter.convert(repositoryRequest.credentials),
        onCredentialsRefreshed: (newSpotifyApiCredentials) {
          repositoryRequest.onCredentialsRefreshed?.call(_credentialsConverter.convertBack(newSpotifyApiCredentials));
        });
  }

  @override
  SpotifyRepositoryRequest convertBack(SpotifyApiRequest apiRequest) {
    throw UnimplementedError();
  }
}
