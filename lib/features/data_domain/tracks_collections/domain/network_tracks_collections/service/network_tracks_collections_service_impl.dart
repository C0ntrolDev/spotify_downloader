import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/auth/domain/local_auth/repositories/local_full_auth_repository.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/repositories/network_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/service/network_tracks_collections_service.dart';

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
