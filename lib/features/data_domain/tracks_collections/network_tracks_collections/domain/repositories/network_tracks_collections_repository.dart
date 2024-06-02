

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

abstract class NetworkTracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      SpotifyRepositoryRequest spotifyRepositoryRequest, TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(SpotifyRepositoryRequest spotifyRepositoryRequest, String url);
}
