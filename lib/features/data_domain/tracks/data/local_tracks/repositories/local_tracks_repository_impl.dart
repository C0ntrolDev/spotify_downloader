import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/data_sources/local_tracks_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/repositories/converters/local_track_dto_to_local_track_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/local_tracks/repositories/converters/local_tracks_collection_dto_to_local_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_track.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/entities/local_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/local_tracks/repositories/local_tracks_repository.dart';

class LocalTracksRepositoryImpl implements LocalTracksRepository {
  LocalTracksRepositoryImpl({required LocalTracksDataSource dataSource}) : _dataSource = dataSource;

  final LocalTracksDataSource _dataSource;

  final LocalTracksCollectionDtoToLocalTracksCollectionConverter _collectionsConverter =
      LocalTracksCollectionDtoToLocalTracksCollectionConverter();
  final LocalTrackDtoToLocalTrackConverter _localTrackConverter = LocalTrackDtoToLocalTrackConverter();

  @override
  Future<Result<Failure, LocalTrack?>> getLocalTrack(
      LocalTracksCollection localTracksCollection, String spotifyId) async {
    try {
      final localDtoTrack = await _dataSource.getLocalTrackFromStorage(
          _collectionsConverter.convertBack(localTracksCollection), spotifyId);
      if (localDtoTrack == null) {
        return const Result.isSuccessful(null);
      }
      return Result.isSuccessful(_localTrackConverter.convert(localDtoTrack));
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
