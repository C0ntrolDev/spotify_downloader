import 'dart:ffi';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/tracks_collectons_history/repositories/converters/tracks_collections_converter.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/repositories/tracks_collections_history_repository.dart';

class TracksCollectionsHistoryRepositoryImpl implements TracksCollectionsHistoryRepository {
  TracksCollectionsHistoryRepositoryImpl({required TracksCollectonsHistoryDataSource dataSource})
      : _dataSource = dataSource;

  final TracksCollectonsHistoryDataSource _dataSource;
  final TracksCollectionsConverter tracksCollectionsConverter = TracksCollectionsConverter();

  @override
  Future<Result<Failure, void>> addTracksCollectionToHistory(TracksCollection tracksCollection) async {
    try {
      await _dataSource
          .addHistoryTracksCollectionToHistory(await tracksCollectionsConverter.convert(tracksCollection));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(TracksCollection tracksCollection) async {
    try {
      await _dataSource
          .deleteHistoryTracksCollectionFromHistory(await tracksCollectionsConverter.convert(tracksCollection));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, List<TracksCollection>?>> getTracksCollectionsHistory() async {
    try {
      final tracksCollectionHistory = await _dataSource.getTracksCollectionHistory();

      if (tracksCollectionHistory != null) {
        var convertedTracksCollectionsHistory = List<TracksCollection>.empty(growable: true);

        for (var historyTracksCollection in tracksCollectionHistory) {
          convertedTracksCollectionsHistory.add(await tracksCollectionsConverter.convertBack(historyTracksCollection));
        }

        return Result<Failure, List<TracksCollection>?>.isSuccessful(convertedTracksCollectionsHistory);
      } else {
        return const Result.isSuccessful(null);
      }
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }
}
