// ignore_for_file: void_checks

import 'dart:ffi';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/data_source/tracks_collectons_history_data_source.dart';
import 'package:spotify_downloader/features/data/history_tracks_collectons/repositories/converters/history_tracks_collections_converter.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';

class TracksCollectionsHistoryRepositoryImpl implements TracksCollectionsHistoryRepository {
  TracksCollectionsHistoryRepositoryImpl({required TracksCollectonsHistoryDataSource dataSource})
      : _dataSource = dataSource;

  final TracksCollectonsHistoryDataSource _dataSource;
  final HistoryTracksCollectionsConverter tracksCollectionsConverter = HistoryTracksCollectionsConverter();

  @override
  Future<Result<Failure, void>> addTracksCollectionToHistory(HistoryTracksCollection tracksCollection) async {
    try {
      await _dataSource
          .addHistoryTracksCollectionToHistory(tracksCollectionsConverter.convert(tracksCollection));
      return const Result<Failure, void>.isSuccessful(Void );
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(HistoryTracksCollection tracksCollection) async {
    try {
      await _dataSource
          .deleteHistoryTracksCollectionFromHistory(tracksCollectionsConverter.convert(tracksCollection));
      return const Result<Failure, void>.isSuccessful(Void);
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
          convertedTracksCollectionsHistory.add(tracksCollectionsConverter.convertBack(historyTracksCollection));
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
