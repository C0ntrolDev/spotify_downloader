import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/domain/repositories/local_full_auth_repository.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/spotify_profile/domain/domain.dart';

class SpotifyProfileServiceImpl extends SpotifyProfileService {
  SpotifyProfileServiceImpl(
      {required LocalFullAuthRepository localFullAuthRepository,
      required SpotifyProfileRepository spotifyProfileRepository})
      : _fullAuthRepository = localFullAuthRepository,
        _spotifyProfileRepository = spotifyProfileRepository;

  final LocalFullAuthRepository _fullAuthRepository;
  final SpotifyProfileRepository _spotifyProfileRepository;

  @override
  Future<Result<Failure, SpotifyProfile>> getSpotifyProfile() async {
    final getFullCredentialsResult = await _fullAuthRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    if (getFullCredentialsResult.result!.refreshToken == null ||
        getFullCredentialsResult.result!.accessToken == null) {
      return Result.notSuccessful(NotAuthorizedFailure());
    }

    return _spotifyProfileRepository.getSpotifyProfile(SpotifyRepositoryRequest(
        credentials: getFullCredentialsResult.result!,
        onCredentialsRefreshed: _fullAuthRepository.saveFullCredentials));
  }
}
