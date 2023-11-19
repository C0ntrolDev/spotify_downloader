import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';

abstract class TracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId();
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl();
}