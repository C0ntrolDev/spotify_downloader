import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';

abstract class NetworkTracksCollectionsService {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url);
}
