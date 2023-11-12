import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/data/models/local_playlist.dart';
import 'package:sqflite/sqflite.dart';

class LocalTracksCollectionsDataSource {

  LocalTracksCollectionsDataSource({
    required LocalDb localDb
  }) : _localDb = localDb;

  final LocalDb _localDb;

  Future<List<LocalTracksCollection>?> getLocalTracksCollections() async {
    final database = _localDb.getDb();

    final mapLocalTracksCollections = await database.query('localTracksCollections');

    if (mapLocalTracksCollections.isEmpty) {
      return null;
    }

    return mapLocalTracksCollections.map((e) => _localTracksCollectionFromMap(e)).toList();
  }

  Future<void> addPlaylist(LocalTracksCollection localTracksCollection) async {
    final database = _localDb.getDb();
    await database.insert('localTracksCollections', _localTracksCollectionToMap(localTracksCollection), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deletePlaylist(LocalTracksCollection localTracksCollection) async {
    final database = _localDb.getDb();
    await database.delete('localTracksCollections', where: 'spotifyId = ?', whereArgs: [localTracksCollection.spotifyId]);
  }


  Map<String, dynamic> _localTracksCollectionToMap(LocalTracksCollection localTracksCollection) {
     return {
      'spotifyId': localTracksCollection.spotifyId,
      'type': localTracksCollection.type.index,
      'name': localTracksCollection.name,
      'openDate' : localTracksCollection.openDate.millisecondsSinceEpoch,
      'image': localTracksCollection.image,
    };
  }

  LocalTracksCollection _localTracksCollectionFromMap(Map<String, dynamic> map) {
    return LocalTracksCollection(
      spotifyId: map['spotifyId'],
      type: LocalPlaylistType.values[map['type'] as int],
      name: map['name'],
      image: map['image'],
      openDate: DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int));
  }
}