import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/spotify_repository_request.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';

abstract class NetworkTracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      SpotifyRepositoryRequest spotifyRepositoryRequest, TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(SpotifyRepositoryRequest spotifyRepositoryRequest, String url);
}
