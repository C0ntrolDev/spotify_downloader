import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/repositories/converters/history_tracks_collections_converter.dart';
import 'package:spotify_downloader/features/data/tracks_collections/history_tracks_collectons/repositories/converters/tracks_collection_to_history_tracks_collection_dto_converter.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

class TracksCollectionsHistoryRepositoryImpl implements TracksCollectionsHistoryRepository {
  TracksCollectionsHistoryRepositoryImpl({required TracksCollectonsHistoryDataSource dataSource})
      : _dataSource = dataSource;

  final TracksCollectonsHistoryDataSource _dataSource;

  final HistoryTracksCollectionsConverter _historyTracksCollectionsConverter = HistoryTracksCollectionsConverter();
  final TracksCollectionToHistoryTracksCollectionDtoConverter _tracksCollectionToHistoryTracksCollectionDtoConverter =
      TracksCollectionToHistoryTracksCollectionDtoConverter();

  @override
  Future<Result<Failure, void>> addTracksCollectionToHistory(TracksCollection tracksCollection) async {
    try {
      await _dataSource.addHistoryTracksCollectionToHistory(
          _tracksCollectionToHistoryTracksCollectionDtoConverter.convert(tracksCollection));
      return const Result<Failure, void>.isSuccessful(null);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(
      HistoryTracksCollection historyTracksCollection) async {
    try {
      await _dataSource.deleteHistoryTracksCollectionFromHistory(
          _historyTracksCollectionsConverter.convert(historyTracksCollection));
      return const Result<Failure, void>.isSuccessful(null);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, List<HistoryTracksCollection>?>> getTracksCollectionsHistory() async {
    try {
      final tracksCollectionHistory = await _dataSource.getTracksCollectionHistory();

      if (tracksCollectionHistory != null) {
        var convertedTracksCollectionsHistory = List<HistoryTracksCollection>.empty(growable: true);

        for (var historyTracksCollection in tracksCollectionHistory) {
          convertedTracksCollectionsHistory
              .add(_historyTracksCollectionsConverter.convertBack(historyTracksCollection));
        }

        return Result<Failure, List<HistoryTracksCollection>?>.isSuccessful(convertedTracksCollectionsHistory);
      } else {
        return const Result.isSuccessful(null);
      }
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}
