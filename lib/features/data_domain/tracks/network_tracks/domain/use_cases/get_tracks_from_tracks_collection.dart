import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/domain.dart';

class GetTracksFromTracksCollection implements UseCase<Failure, TracksGettingObserver, (TracksCollection, int)> {
  GetTracksFromTracksCollection(
      {required NetworkTracksRepository networkTracksRepository, required LocalFullAuthRepository authRepository})
      : _networkTracksRepository = networkTracksRepository,
        _authRepository = authRepository;

  final NetworkTracksRepository _networkTracksRepository;
  final LocalFullAuthRepository _authRepository;

  @override
  Future<Result<Failure, TracksGettingObserver>> call((TracksCollection, int) params) async {
    final getFullCredentialsResult = await _authRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    final observer = await _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        spotifyRepositoryRequest: SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _authRepository.saveFullCredentials),
        tracksCollection: params.$1,
        offset: params.$2));

    return Result.isSuccessful(observer);
  }
}
