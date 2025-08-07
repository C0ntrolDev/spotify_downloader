import 'dart:async';

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/auth/local_auth/local_auth.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/repository/download_tracks_settings_repository.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/download_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/local_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/service/get_tracks_service.dart';

class GetTracksServiceImpl implements GetTracksService {
  GetTracksServiceImpl(
      {required NetworkTracksRepository networkTracksRepository,
      required DownloadTracksRepository downloadTracksRepository,
      required LocalTracksRepository localTracksRepository,
      required LocalFullAuthRepository authRepository,
      required DownloadTracksSettingsRepository downloadTracksSettingsRepository})
      : _networkTracksRepository = networkTracksRepository,
        _authRepository = authRepository;

  final NetworkTracksRepository _networkTracksRepository;
  final LocalFullAuthRepository _authRepository;

  @override
  Future<Result<Failure, TracksGettingObserver>> getTracksFromTracksCollection(
      {required TracksCollectionId id, int offset = 0}) async {
    final getFullCredentialsResult = await _authRepository.getFullCredentials();
    if (!getFullCredentialsResult.isSuccessful) {
      return Result.notSuccessful(getFullCredentialsResult.failure);
    }

    final observer = await _networkTracksRepository.getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs(
        spotifyRepositoryRequest: SpotifyRepositoryRequest(
            credentials: getFullCredentialsResult.result!,
            onCredentialsRefreshed: _authRepository.saveFullCredentials),
        tracksCollectionId: id,
        offset: offset));

    return Result.isSuccessful(observer);
  }
}
