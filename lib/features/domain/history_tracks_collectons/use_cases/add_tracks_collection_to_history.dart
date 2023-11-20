import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/repositories/tracks_collections_history_repository.dart';

class AddHistoryTracksCollectionToHistory implements UseCase<Failure, void, HistoryTracksCollection> {
  AddHistoryTracksCollectionToHistory({required TracksCollectionsHistoryRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final TracksCollectionsHistoryRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, void>> call(HistoryTracksCollection historyTracksCollection) async {
    return await _historyPlaylistsRepository.addTracksCollectionToHistory(historyTracksCollection);
  }
}
