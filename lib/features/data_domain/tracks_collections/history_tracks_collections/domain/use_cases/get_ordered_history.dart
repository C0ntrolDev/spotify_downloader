import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/history_tracks_collections.dart';

class GetOrderedHistory implements UseCase<Failure, List<HistoryTracksCollection>?, void> {
  GetOrderedHistory({required TracksCollectionsHistoryRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final TracksCollectionsHistoryRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, List<HistoryTracksCollection>?>> call(void params) async {
    final historyPlaylistsResult = await _historyPlaylistsRepository.getTracksCollectionsHistory();
    if (historyPlaylistsResult.isSuccessful) {
      historyPlaylistsResult.result?.sort((e1, e2) => e2.openDate?.compareTo(e1.openDate ?? DateTime.now()) ?? 1);
    }
    return historyPlaylistsResult;
  }
}
