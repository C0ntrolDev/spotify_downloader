import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repository/local_auth_repository.dart';
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
  Future<Result<Failure, SpotifyProfile>> getSpotifyProfile() async {
    final authCredentialsResult = await _localAuthRepository.getAuthCredentials();
    if (!authCredentialsResult.isSuccessful) {
      return Result.notSuccessful(authCredentialsResult.failure);
    }

    if (authCredentialsResult.result!.refreshToken == null || authCredentialsResult.result!.accessToken == null) {
      return Result.notSuccessful(NotAuthorizedFailure());
    }

    return _spotifyProfileRepository.getSpotifyProfile(SpotifyRepositoryRequest(
        clientCredentials: authCredentialsResult.result!,
        onCredentialsRefreshed: _localAuthRepository.saveAuthorizedCredentials));
  }
}
