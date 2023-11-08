import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/shared/data/models/local_playlist.dart';
import 'package:sqflite/sqflite.dart';

class LocalPlaylistsDataSource {

  LocalPlaylistsDataSource({
    required LocalDb localDb
  }) : _localDb = localDb;

  LocalDb _localDb;

  Future<List<LocalPlaylist>?> getPlaylists() async {
    final database = _localDb.getDb();

    final mapPlaylists = await database.query('localPlaylists');

    if (mapPlaylists.isEmpty) {
      return null;
    }

    return mapPlaylists.map((e) => _localPlaylistFromMap(e)).toList();
  }

  Future<void> addPlaylist(LocalPlaylist localPlaylist) async {
    final database = _localDb.getDb();
    await database.insert('localPlaylists', _localPlaylistToMap(localPlaylist), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deletePlaylist(LocalPlaylist localPlaylist) async {
    final database = _localDb.getDb();
    await database.delete('localPlaylists', where: 'spotifyId = ?', whereArgs: [localPlaylist.spotifyId]);
  }


  Map<String, dynamic> _localPlaylistToMap(LocalPlaylist localPlaylist) {
     return {
      'spotifyId': localPlaylist.spotifyId,
      'name': localPlaylist.name,
      'openDate' : localPlaylist.openDate.millisecondsSinceEpoch,
      'image': localPlaylist.image,
    };
  }

  LocalPlaylist _localPlaylistFromMap(Map<String, dynamic> map) {
    return LocalPlaylist(
      spotifyId: map['spotifyId'],
      name: map['name'],
      image: map['image'],
      openDate: DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int));
  }
}