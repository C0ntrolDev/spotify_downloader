import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/consts/local_paths.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbImpl extends LocalDb {
  late Database _dataBase;

  @override
  Future<void> cleanDb() async {
    final localDirectoryPath = (await getApplicationSupportDirectory()).path;
    final absoluteDbPath = '$localDirectoryPath$dbPath';

    final dbFile = File(absoluteDbPath);

    await dbFile.delete();
    await initDb();
  }

  @override
  Database getDb() => _dataBase;

  @override
  Future<void> initDb() async {
    final localDirectoryPath = (await getApplicationSupportDirectory()).path;
    final absoluteDbPath = '$localDirectoryPath$dbPath';

    final dbFile = File(absoluteDbPath);
    Database database;

    if (await dbFile.exists()) {
      database = await openDatabase(absoluteDbPath);
    } else {
      database = await openDatabase(
        absoluteDbPath,
        version: 1,
        onCreate: (db, version) {
          db.execute("CREATE TABLE tracksCollectionsHistory ("
              "spotifyId TEXT PRIMARY KEY,"
              "type INTEGER NOT NULL,"
              "openDate INTEGER NOT NULL,"
              "name TEXT NOT NULL,"
              "imageUrl TEXT NOT NULL"
              ")");

          db.execute("CREATE TABLE downloadTracksCollectionsGroups ("
              "directoryPath TEXT NOT NULL"
              ")");

          db.execute("CREATE TABLE downloadTracksCollections ("
              "spotifyId TEXT NOT NULL,"
              "type INTEGER NOT NULL,"
              "downloadTracksCollectionsGroup_directoryPath TEXT NOT NULL,"
              "FOREIGN KEY (downloadTracksCollectionsGroup_directoryPath) REFERENCES downloadTracksCollectionsGroups (directoryPath) ON DELETE CASCADE,"
              "PRIMARY KEY (spotifyId, type, downloadTracksCollectionsGroup_directoryPath)"
              ")");

          db.execute("CREATE TABLE downloadTracks ("
              "downloadTracksCollection_spotifyId TEXT NOT NULL,"
              "downloadTracksCollection_type INTEGER NOT NULL,"
              "downloadTracksCollectionGroup_directoryPath TEXT NOT NULL,"
              "spotifyId TEXT NOT NULL,"
              "youtubeUrl TEXT NOT NULL,"
              "savePath TEXT NOT NULL,"
              "FOREIGN KEY (downloadTracksCollectionGroup_directoryPath) REFERENCES downloadTracksCollections (downloadTracksCollectionsGroup_directoryPath) ON DELETE CASCADE,"
              "FOREIGN KEY (downloadTracksCollection_spotifyId) REFERENCES downloadTracksCollections (spotifyId) ON DELETE CASCADE,"
              "FOREIGN KEY (downloadTracksCollection_type) REFERENCES downloadTracksCollections (type) ON DELETE CASCADE,"
              "PRIMARY KEY (downloadTracksCollection_spotifyId, downloadTracksCollection_type, spotifyId)"
              ")");
        },
      );
    }

    _dataBase = database;
  }
}
