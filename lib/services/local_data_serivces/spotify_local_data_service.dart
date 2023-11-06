import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/models/db/local/local_playlist.dart';
import 'package:spotify_downloader/models/db/local/local_track.dart';
import 'package:sqflite/sqflite.dart';

class SpotifyLocalDataService {
  final Database _database;

  SpotifyLocalDataService._create({required Database database}) : _database = database;

  static Future<SpotifyLocalDataService> create() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = "${documentsDirectory.path}user_history.db";

    final dataBaseExist =  await databaseExists(path);

    Database database;

    if (dataBaseExist == false) {
      database = await openDatabase(path, version: 1, onCreate: (db, version) {
        db.execute("CREATE TABLE localPlaylists ("
          "spotifyId TEXT PRIMARY KEY,"
          "openDate INTEGER NOT NULL,"
          "name TEXT NOT NULL,"
          "image BLOB NOT NULL"
          ")");
        db.execute("CREATE TABLE localTracks ("
          "localPlaylist_spotifyId TEXT NOT NULL"
          "spotifyId TEXT NOT NULL,"
          "isLoaded INTEGER NOT NULL,"
          "youtubeUrl TEXT,"
          "FOREIGN KEY (localPlaylist_spotifyId) REFERENCES localPlaylists (spotifyId) ON DELETE CASCASDE,"
          "PRIMARY KEY (localPlaylist_spotifyId, spotifyId)"
          ")");
      },);
    }
    else {
      database = await openDatabase(path);
    }

    return SpotifyLocalDataService._create(database: database);
  }

  void deleteDb() async {


    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = "${documentsDirectory.path}user_history.db";

    final file = File(path);
    await file.delete();
  }

  Future<void> addPlaylistToHistory(LocalPlaylist localPlaylist) async {
    await _database.insert('localPlaylists', localPlaylist.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deletePlaylistFromHistory(String spotifyId) async {
    await _database.delete('localPlaylists', where: 'spotifyId = ?', whereArgs: [spotifyId]);
  }

  Future<List<LocalPlaylist>?> getPlaylistsHistory() async {
    final mapPlaylists = await _database.query('localPlaylists');

    if (mapPlaylists.isEmpty) {
      return null;
    }

    return mapPlaylists.map((e) => LocalPlaylist.fromMap(e)).toList();
  }

  Future<List<LocalTrack>?> getTracksByPlaylistId(String spotifyId) async {
    final mapTracks = await _database.query('localTracks', where: 'localPlaylist_spotifyId = ?', whereArgs: [spotifyId]);

    if (mapTracks.isEmpty) {
      return null;
    }

    return mapTracks.map((e) => LocalTrack.fromMap(e)).toList();
  }

  Future<void> deleteTrackToPlaylist(LocalTrack localTrack) async {
    await _database.delete('localPlaylists', where: 'spotifyId = ?, localPlaylist_spotifyId', whereArgs: [localTrack.spotifyId, localTrack.localPlaylistSpotifyId]);
  }

  Future<void> addTrackToPlaylist(LocalTrack localTrack) async {
    await _database.insert('localTracks', localTrack.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

}
