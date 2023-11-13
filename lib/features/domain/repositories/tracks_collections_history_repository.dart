import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';

abstract class TracksCollectionsHistoryRepository {

  Future<Result<Failure,List<TracksCollection>?>> getTracksCollectionsHistory(); 
  Future<Result<Failure, void>> addTracksCollectionToHistory(TracksCollection playlist);
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(TracksCollection playlist);
  
}