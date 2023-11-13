import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/models/history_tracks_collection.dart';
import 'package:sqflite/sqflite.dart';

class TracksCollectonsHistoryDataSource {
  TracksCollectonsHistoryDataSource({required LocalDb localDb}) : _localDb = localDb;

  final LocalDb _localDb;

  Future<void> addHistoryTracksCollectionToHistory(HistoryTracksCollection historyTracksCollection) async {
    final database = _localDb.getDb();
    await database.insert('tracksCollectionsHistory', _historyTracksCollectionToMap(historyTracksCollection),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteHistoryTracksCollectionFromHistory(HistoryTracksCollection historyTracksCollection) async {
    final database = _localDb.getDb();
    await database
        .delete('tracksCollectionsHistory', where: 'spotifyId = ?', whereArgs: [historyTracksCollection.spotifyId]);
  }

  Future<List<HistoryTracksCollection>?> getTracksCollectionHistory() async {
    final database = _localDb.getDb();

    final mapLocalTracksCollections = await database.query('tracksCollectionsHistory');

    if (mapLocalTracksCollections.isEmpty) {
      return null;
    }

    return mapLocalTracksCollections.map((e) => _historyTracksCollectionFromMap(e)).toList();
  }

  Map<String, dynamic> _historyTracksCollectionToMap(HistoryTracksCollection historyTracksCollection) {
    return {
      'spotifyId': historyTracksCollection.spotifyId,
      'type': historyTracksCollection.type.index,
      'name': historyTracksCollection.name,
      'openDate': historyTracksCollection.openDate.millisecondsSinceEpoch,
      'image': historyTracksCollection.image,
    };
  }

  HistoryTracksCollection _historyTracksCollectionFromMap(Map<String, dynamic> map) {
    return HistoryTracksCollection(
        spotifyId: map['spotifyId'],
        type: HistoryTracksCollectionType.values[map['type'] as int],
        name: map['name'],
        image: map['image'],
        openDate: DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int));
  }
}
