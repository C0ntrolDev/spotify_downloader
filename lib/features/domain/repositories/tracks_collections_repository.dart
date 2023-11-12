import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';

abstract class TracksCollectionsRepository {
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl();
  Future<Result<Failure, String>> getTracksCollectionBestQualityImage(TracksCollection tracksCollection);
}