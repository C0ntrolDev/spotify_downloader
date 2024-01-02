import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_track_dto.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto_type.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collections_group_dto.dart';
import 'package:sqflite/sqflite.dart';

class LocalTracksDataSource {
  LocalTracksDataSource({required LocalDb localDb}) : _localDb = localDb;

  final LocalDb _localDb;

  Future<void> saveLocalTrackInStorage(LocalTrackDto localTrackDto) async {
    final database = _localDb.getDb();
    await database.insert(
        'downloadTracksCollectionsGroups', _localTracksCollectionsGroupDtoToMap(localTrackDto.tracksCollection.group));
    await database.insert('downloadTracksCollections', _localTracksCollectionDtoToMap(localTrackDto.tracksCollection),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await database.insert('downloadTracks', _localTrackDtoToMap(localTrackDto),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeLocalTrackFromStorage(LocalTrackDto localTrackDto) async {
    final database = _localDb.getDb();
    await database.rawDelete('''
      DELETE dt
      FROM downloadTracks dt
      JOIN downloadTracksCollections dtc ON dtc.downloadTracksCollection_spotifyId = dt.downloadTracksCollection_spotifyId
                                    AND dtc.downloadTracksCollection_type = dt.downloadTracksCollection_type
      JOIN downloadTracksCollectionsGroups dtcg ON dtcg.directoryPath = dtc.downloadTracksCollectionsGroups_directoryPath
      WHERE dt.spotifyId = ? 
      AND dtc.spotifyId = ?
      AND dtc.type = ?       
      AND dtcg.directoryPath = ?;
    ''', [
      localTrackDto.spotifyId,
      localTrackDto.tracksCollection.spotifyId,
      localTrackDto.tracksCollection.type.index,
      localTrackDto.tracksCollection.group.directoryPath
    ]);
  }

  Future<LocalTrackDto?> getLocalTrackFromStorage(
      LocalTracksCollectionDto localTracksCollectionDto, String spotifyId) async {
    final database = _localDb.getDb();
    final rawLocalTracks = await database.rawQuery('''
      SELECT dt.*, dtcg.savePath AS group_directoryPath
      FROM downloadTracks dt
      JOIN downloadTracksCollections dtc ON dtc.downloadTracksCollection_spotifyId = dt.downloadTracksCollection_spotifyId
                                    AND dtc.downloadTracksCollection_type = dt.downloadTracksCollection_type
      JOIN downloadTracksCollectionsGroups dtcg ON dtcg.directoryPath = dtc.downloadTracksCollectionsGroups_directoryPath
      WHERE dt.spotifyId = ? 
      AND dtc.spotifyId = ?
      AND dtc.type = ? 
      AND dtcg.directoryPath = ?
    ''', [
      spotifyId,
      localTracksCollectionDto.spotifyId,
      localTracksCollectionDto.type.index,
      localTracksCollectionDto.group.directoryPath
    ]);
    return rawLocalTracks.map((rawLocalTrack) => _localTrackDtoFromMap(rawLocalTrack)).firstOrNull;
  }

  Map<String, dynamic> _localTrackDtoToMap(LocalTrackDto localTrackDto) {
    return {
      'downloadTracksCollection_spotifyId': localTrackDto.tracksCollection.spotifyId,
      'downloadTracksCollection_type': localTrackDto.tracksCollection.type.index,
      'spotifyId': localTrackDto.spotifyId,
      'youtubeUrl': localTrackDto.youtubeUrl,
      'savePath': localTrackDto.savePath
    };
  }

  Map<String, dynamic> _localTracksCollectionDtoToMap(LocalTracksCollectionDto localTracksCollectionDto) {
    return {
      'spotifyId': localTracksCollectionDto.spotifyId,
      'type': localTracksCollectionDto.type.index,
      'downloadTracksCollectionsGroups_directoryPath': localTracksCollectionDto.group.directoryPath
    };
  }

  Map<String, dynamic> _localTracksCollectionsGroupDtoToMap(
      LocalTracksCollectionsGroupDto localTracksCollectionsGroupDto) {
    return {'directoryPath': localTracksCollectionsGroupDto.directoryPath};
  }

  LocalTrackDto _localTrackDtoFromMap(Map<String, dynamic> map) {
    return LocalTrackDto(
      tracksCollection: LocalTracksCollectionDto(
          spotifyId: map['downloadTracksCollection_spotifyId'],
          type: LocalTracksCollectionDtoType.values[map['downloadTracksCollection_type'] as int],
          group: LocalTracksCollectionsGroupDto(
            directoryPath: map['group_directoryPath'])),
      spotifyId: map['spotifyId'],
      youtubeUrl: map['youtubeUrl'],
      savePath: map['savePath'],
    );
  }
}
