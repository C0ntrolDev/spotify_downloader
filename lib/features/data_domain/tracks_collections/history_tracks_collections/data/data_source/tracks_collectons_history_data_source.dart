import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/data/models/models.dart';
import 'package:sqflite/sqflite.dart';

class TracksCollectonsHistoryDataSource {
  TracksCollectonsHistoryDataSource({required LocalDb localDb}) : _localDb = localDb;

  final LocalDb _localDb;

  Future<void> addHistoryTracksCollectionToHistory(HistoryTracksCollectionDTO historyTracksCollection) async {
    final database = _localDb.getDb();
    await database.insert('tracksCollectionsHistory', _historyTracksCollectionToMap(historyTracksCollection),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteHistoryTracksCollectionFromHistory(HistoryTracksCollectionDTO historyTracksCollection) async {
    final database = _localDb.getDb();
    await database
        .delete('tracksCollectionsHistory', where: 'spotifyId = ?', whereArgs: [historyTracksCollection.spotifyId]);
  }

  Future<List<HistoryTracksCollectionDTO>?> getTracksCollectionHistory() async {
    final database = _localDb.getDb();

    final mapLocalTracksCollections = await database.query('tracksCollectionsHistory');

    if (mapLocalTracksCollections.isEmpty) {
      return null;
    }

    return mapLocalTracksCollections.map((e) => _historyTracksCollectionFromMap(e)).toList();
  }

  Map<String, dynamic> _historyTracksCollectionToMap(HistoryTracksCollectionDTO historyTracksCollection) {
    return {
      'spotifyId': historyTracksCollection.spotifyId,
      'type': historyTracksCollection.type.index,
      'name': historyTracksCollection.name,
      'openDate': historyTracksCollection.openDate.millisecondsSinceEpoch,
      'imageUrl': historyTracksCollection.imageUrl,
    };
  }

  HistoryTracksCollectionDTO _historyTracksCollectionFromMap(Map<String, dynamic> map) {
    return HistoryTracksCollectionDTO(
        spotifyId: map['spotifyId'],
        type: HistoryTracksCollectionType.values[map['type'] as int],
        name: map['name'],
        imageUrl: map['imageUrl'],
        openDate: DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int));
  }
}
