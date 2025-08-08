import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/network_tracks_collections.dart';

class GetTracksCollectionByTypeAndSpotifyId
    implements UseCase<Failure, TracksCollection, (TracksCollectionType, String)> {

  GetTracksCollectionByTypeAndSpotifyId({required LocalFullAuthRepository fullAuthRepository, required NetworkTracksCollectionsRepository networkTracksCollectionsRepository}) : _fullAuthRepository = fullAuthRepository, _networkTracksCollectionsRepository = networkTracksCollectionsRepository;


  final LocalFullAuthRepository _fullAuthRepository;
  final NetworkTracksCollectionsRepository _networkTracksCollectionsRepository;


  @override
  Future<Result<Failure, TracksCollection>> call((TracksCollectionType, String) args) async {

    final getFullCredentialsResult = await _fullAuthRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return _networkTracksCollectionsRepository.getTracksCollectionByTypeAndSpotifyId(
        SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _fullAuthRepository.saveFullCredentials),
        args.$1,
        args.$2);
  }
}
