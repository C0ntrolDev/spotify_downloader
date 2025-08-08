import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
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
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      TracksCollectionType type, String spotifyId) async {
    final getFullCredentialsResult = await _fullAuthRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    return _networkTracksCollectionsRepository.getTracksCollectionByTypeAndSpotifyId(
        SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _fullAuthRepository.saveFullCredentials),
        type,
        spotifyId);
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
