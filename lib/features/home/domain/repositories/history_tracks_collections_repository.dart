import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/home/domain/entities/tracks_collection.dart';

abstract class HistoryTracksCollectionsRepository {

  Future<Result<Failure,List<TracksCollection>?>> getHistoryPlaylists(); 
  Future<Result<Failure, void>> addPlaylistInHistory(TracksCollection playlist);
  Future<Result<Failure, void>> deletePlaylistFromHistory(TracksCollection playlist);
  
}