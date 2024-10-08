import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

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
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }

  @override
  Future<Result<Failure, void>> deleteTracksCollectionFromHistory(
      HistoryTracksCollection historyTracksCollection) async {
    try {
      await _dataSource.deleteHistoryTracksCollectionFromHistory(
          _historyTracksCollectionsConverter.convert(historyTracksCollection));
      return const Result<Failure, void>.isSuccessful(null);
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
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
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }
  }
}
