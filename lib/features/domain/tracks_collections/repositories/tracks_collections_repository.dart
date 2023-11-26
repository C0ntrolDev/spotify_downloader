import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

abstract class TracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(TracksCollectionType type, String spotifyId);
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url);
}