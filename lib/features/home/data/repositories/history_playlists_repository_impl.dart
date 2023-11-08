import 'dart:ffi';
import 'dart:typed_data';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/home/data/data_sources/local_playlists_data_source.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_playlists_repository.dart';
import 'package:spotify_downloader/features/shared/data/models/local_playlist.dart';
import 'package:http/http.dart' as http;

class HistoryPlaylistsRepositoryImpl implements HistoryPlaylistsRepository {
  HistoryPlaylistsRepositoryImpl({required this.localPlaylistsDataSource});

  LocalPlaylistsDataSource localPlaylistsDataSource;

  @override
  Future<Result<Failure, void>> addPlaylistInHistory(Playlist playlist) async {
    try {
      await localPlaylistsDataSource.addPlaylist(await _playlistToLocalPlaylist(playlist));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> deletePlaylistFromHistory(Playlist playlist) async {
    try {
      await localPlaylistsDataSource.deletePlaylist(await _playlistToLocalPlaylist(playlist));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, List<Playlist>?>> getHistoryPlaylists() async {
    try {
      final historyPlaylists = await localPlaylistsDataSource.getPlaylists();

      if (historyPlaylists != null) {
        return Result<Failure, List<Playlist>?>.isSuccessful(
          historyPlaylists.map((lp) => _localPlaylistToPlaylist(lp)).toList());
      }
      else {
        return const Result.isSuccessful(null);
      }
      
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  Future<LocalPlaylist> _playlistToLocalPlaylist(Playlist playlist) async {
    Uint8List? image;

    if (playlist.image != null) {
      image = playlist.image;
    }

    if (playlist.imageUrl != null) {
      final response = await http.get(Uri.parse(playlist.imageUrl!));

      if (response.statusCode == 200) {
        image = response.bodyBytes;
      }
    }

    return LocalPlaylist(spotifyId: playlist.spotifyId, name: playlist.name, openDate: playlist.openDate, image: image);
  }

  Playlist _localPlaylistToPlaylist(LocalPlaylist localPlaylist) {
    return Playlist.withLocalImage(
        spotifyId: localPlaylist.spotifyId,
        name: localPlaylist.name,
        openDate: localPlaylist.openDate,
        image: localPlaylist.image);
  }
}
