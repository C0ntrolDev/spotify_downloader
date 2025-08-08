import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/network_tracks_collections.dart';

class GetTracksCollectionByUrl implements UseCase<Failure, TracksCollection, String> {
  
  GetTracksCollectionByUrl(
      {required LocalFullAuthRepository fullAuthRepository,
      required NetworkTracksCollectionsRepository networkTracksCollectionsRepository})
      : _fullAuthRepository = fullAuthRepository,
        _networkTracksCollectionsRepository = networkTracksCollectionsRepository;

  final LocalFullAuthRepository _fullAuthRepository;
  final NetworkTracksCollectionsRepository _networkTracksCollectionsRepository;

  @override
  Future<Result<Failure, TracksCollection>> call(String url) async {
    final getFullCredentialsResult = await _fullAuthRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return _networkTracksCollectionsRepository.getTracksCollectionByUrl(
        SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _fullAuthRepository.saveFullCredentials),
        url);
  }
}
