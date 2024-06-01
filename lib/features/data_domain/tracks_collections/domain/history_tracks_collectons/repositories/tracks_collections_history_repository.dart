import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';

abstract class TracksCollectionsHistoryRepository {

  Future<Result<Failure,List<HistoryTracksCollection>?>> getTracksCollectionsHistory(); 
  Future<Result<Failure, void>> addTracksCollectionToHistory(TracksCollection tracksCollection);
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(HistoryTracksCollection historyTracksCollection);
  
}