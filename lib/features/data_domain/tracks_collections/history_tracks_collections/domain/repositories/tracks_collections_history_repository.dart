import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/domain.dart';

abstract class TracksCollectionsHistoryRepository {

  Future<Result<Failure,List<HistoryTracksCollection>?>> getTracksCollectionsHistory(); 
  Future<Result<Failure, void>> addTracksCollectionToHistory(TracksCollection tracksCollection);
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(HistoryTracksCollection historyTracksCollection);
  
}