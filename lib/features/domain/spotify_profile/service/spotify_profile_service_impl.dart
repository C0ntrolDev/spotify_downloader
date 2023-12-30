import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repository/local_auth_repository.dart';
import 'package:spotify_downloader/features/domain/shared/authorized_client_credentials.dart';
import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/repository/spotify_profile_repostitory.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/service/spotify_profile_service.dart';

class SpotifyProfileServiceImpl extends SpotifyProfileService {
  SpotifyProfileServiceImpl(
      {required LocalAuthRepository localAuthRepository, required SpotifyProfileRepository spotifyProfileRepository})
      : _localAuthRepository = localAuthRepository,
        _spotifyProfileRepository = spotifyProfileRepository;

  final LocalAuthRepository _localAuthRepository;
  final SpotifyProfileRepository _spotifyProfileRepository;

  @override
  Future<Result<Failure, SpotifyProfile>> getSpotifyProfile(AuthorizedClientCredentials clientCredentials) {
    return _spotifyProfileRepository.getSpotifyProfile(SpotifyRepositoryRequest(
        clientCredentials: clientCredentials,
        onCredentialsRefreshed: _updateRefreshToken));
  }

  _updateRefreshToken(newRefreshToken) async {
    final getCredentialsResult = await _localAuthRepository.getAuthCredentials();
    if (getCredentialsResult.isSuccessful) {
      final clientCredentials = getCredentialsResult.result!;
      _localAuthRepository.saveAuthCredentials(AuthorizedClientCredentials(
          clientId: clientCredentials.clientId,
          clientSecret: clientCredentials.clientSecret,
          refreshToken: newRefreshToken));
    }
  }
}
