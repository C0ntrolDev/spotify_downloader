import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';

abstract class NetworkTracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      SpotifyRepositoryRequest spotifyRepositoryRequest, TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(SpotifyRepositoryRequest spotifyRepositoryRequest, String url);
}
