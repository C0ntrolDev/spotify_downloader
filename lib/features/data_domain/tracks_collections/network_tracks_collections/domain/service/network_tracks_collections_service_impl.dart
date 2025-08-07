import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/network_tracks_collections.dart';

class NetworkTracksCollectionsServiceImpl implements NetworkTracksCollectionsService {
  NetworkTracksCollectionsServiceImpl(
      {required LocalFullAuthRepository fullAuthRepository,
      required NetworkTracksCollectionsRepository networkTracksCollectionsRepository})
      : _fullAuthRepository = fullAuthRepository,
        _networkTracksCollectionsRepository = networkTracksCollectionsRepository;

  final LocalFullAuthRepository _fullAuthRepository;
  final NetworkTracksCollectionsRepository _networkTracksCollectionsRepository;

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionById(
      TracksCollectionId id) async {
    final getFullCredentialsResult = await _fullAuthRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return _networkTracksCollectionsRepository.getTracksCollectionById(
        SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _fullAuthRepository.saveFullCredentials),
        id);
  }

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url) async {
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
