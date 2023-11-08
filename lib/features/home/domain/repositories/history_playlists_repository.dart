import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';

abstract class HistoryPlaylistsRepository {

  Future<Result<Failure,List<Playlist>?>> getHistoryPlaylists(); 
  Future<Result<Failure, void>> addPlaylistInHistory(Playlist playlist);
  Future<Result<Failure, void>> deletePlaylistFromHistory(Playlist playlist);
  
}