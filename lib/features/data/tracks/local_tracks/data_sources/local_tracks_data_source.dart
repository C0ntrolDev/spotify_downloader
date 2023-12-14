import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_track_dto.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto_type.dart';
import 'package:sqflite/sqflite.dart';

class LocalTracksDataSource {
  LocalTracksDataSource({required LocalDb localDb}) : _localDb = localDb;

  final LocalDb _localDb;

  Future<void> saveLocalTrackInStorage(LocalTrackDto localTrackDto) async {
    final database = _localDb.getDb();
    await database.insert('downloadTracksCollections', _localTracksCollectionDtoToMap(localTrackDto.tracksCollection),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await database.insert('downloadTracks', _localTrackDtoToMap(localTrackDto),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeLocalTrackFromStorage(LocalTrackDto localTrackDto) async {
    final database = _localDb.getDb();
    await database.delete('downloadTracks',
        where: 'spotifyId = ? and downloadTracksCollection_spotifyId = ? and downloadTracksCollection_type = ?',
        whereArgs: [
          localTrackDto.spotifyId,
          localTrackDto.tracksCollection.spotifyId,
          localTrackDto.tracksCollection.type.index
        ]);
  }

  Future<LocalTrackDto?> getLocalTrackFromStorage(
      LocalTracksCollectionDto localTracksCollectionDto, String spotifyId) async {
    final database = _localDb.getDb();
    final rawLocalTracks = await database.query('downloadTracks',
        where: 'downloadTracksCollection_spotifyId = ? and downloadTracksCollection_type = ? and spotifyId = ?',
        whereArgs: [localTracksCollectionDto.spotifyId, localTracksCollectionDto.type.index, spotifyId]);
    return rawLocalTracks.map((rawLocalTrack) => _localTrackDtoFromMap(rawLocalTrack)).firstOrNull;
  }

  Map<String, dynamic> _localTracksCollectionDtoToMap(LocalTracksCollectionDto localTracksCollectionDto) {
    return {'spotifyId': localTracksCollectionDto.spotifyId, 'type': localTracksCollectionDto.type.index};
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

  LocalTrackDto _localTrackDtoFromMap(Map<String, dynamic> map) {
    return LocalTrackDto(
      tracksCollection: LocalTracksCollectionDto(
          spotifyId: map['downloadTracksCollection_spotifyId'],
          type: LocalTracksCollectionDtoType.values[map['downloadTracksCollection_type'] as int]),
      spotifyId: map['spotifyId'],
      youtubeUrl: map['youtubeUrl'],
      savePath: map['savePath'],
    );
  }
}
