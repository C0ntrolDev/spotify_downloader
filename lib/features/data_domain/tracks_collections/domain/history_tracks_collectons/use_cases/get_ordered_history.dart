// ignore_for_file: prefer_void_to_null

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';

class GetOrderedHistory implements UseCase<Failure, List<HistoryTracksCollection>?, Null> {
  GetOrderedHistory({required TracksCollectionsHistoryRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final TracksCollectionsHistoryRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, List<HistoryTracksCollection>?>> call(Null params) async {
    final historyPlaylistsResult = await _historyPlaylistsRepository.getTracksCollectionsHistory();
    if (historyPlaylistsResult.isSuccessful) {
      historyPlaylistsResult.result?.sort((e1, e2) => e2.openDate?.compareTo(e1.openDate ?? DateTime.now()) ?? 1);
    }
    return historyPlaylistsResult;
  }
}
