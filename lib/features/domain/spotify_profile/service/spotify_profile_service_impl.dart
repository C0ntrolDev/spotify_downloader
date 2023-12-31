import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/auth/local_auth/repositories/local_full_auth_repository.dart';
import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/entities/spotify_profile.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/repository/spotify_profile_repostitory.dart';
import 'package:spotify_downloader/features/domain/spotify_profile/service/spotify_profile_service.dart';

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
