import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/consts/local_paths.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbImpl extends LocalDb {

  late Database _dataBase;

  @override
  Future<void> cleanDb() async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteDbPath = '$localDirectoryPath$dbPath';

    final dbFile = File(absoluteDbPath);
    
    await dbFile.delete();
    await initDb();
  }

  @override
  Database getDb() => _dataBase;

  @override
  Future<void> initDb() async {
    final localDirectoryPath = (await getApplicationDocumentsDirectory()).path;
    final absoluteDbPath = '$localDirectoryPath$dbPath';

    final dbFile = File(absoluteDbPath);
    Database database;

    if (await dbFile.exists()) {
      database = await openDatabase(absoluteDbPath);
    }
    else {
      database = await openDatabase(absoluteDbPath, version: 1, onCreate: (db, version) {
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

    _dataBase = database;
  }

}