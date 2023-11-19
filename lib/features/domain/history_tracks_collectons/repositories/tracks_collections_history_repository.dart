import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';

abstract class TracksCollectionsHistoryRepository {

  Future<Result<Failure,List<HistoryTracksCollection>?>> getTracksCollectionsHistory(); 
  Future<Result<Failure, void>> addTracksCollectionToHistory(HistoryTracksCollection playlist);
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(HistoryTracksCollection playlist);
  
}