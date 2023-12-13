import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/data_sources/local_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/repositories/converters/local_track_dto_to_local_track_converter.dart';
import 'package:spotify_downloader/features/data/tracks/local_tracks/repositories/converters/local_tracks_collection_dto_to_local_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/local_tracks/repositories/local_tracks_repository.dart';

class LocalTracksRepositoryImpl implements LocalTracksRepository {
  LocalTracksRepositoryImpl({required LocalTracksDataSource dataSource}) : _dataSource = dataSource;

  final LocalTracksDataSource _dataSource;

  final LocalTracksCollectionDtoToLocalTracksCollectionConverter _collectionsConverter =
      LocalTracksCollectionDtoToLocalTracksCollectionConverter();
  final LocalTrackDtoToLocalTrackConverter _localTrackConverter = LocalTrackDtoToLocalTrackConverter();

  @override
  Future<Result<Failure, List<LocalTrack>>> getLocalTracksByLocalTracksCollection(
      LocalTracksCollection localTracksCollection) async {
    try {
      final localDtoTracks = await _dataSource
          .getLocalTracksFromStorageByLocalTracksCollection(_collectionsConverter.convertBack(localTracksCollection));
      return Result.isSuccessful(localDtoTracks.map((dtoTrack) => _localTrackConverter.convert(dtoTrack)).toList());
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> saveLocalTrack(LocalTrack localTrack) async {
    try {
      await _dataSource.saveLocalTrackInStorage(_localTrackConverter.convertBack(localTrack));
      return const Result.isSuccessful(null);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> removeLocalTrack(LocalTrack localTrack) async {
    try {
      await _dataSource.removeLocalTrackFromStorage(_localTrackConverter.convertBack(localTrack));
      return const Result.isSuccessful(null);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}
