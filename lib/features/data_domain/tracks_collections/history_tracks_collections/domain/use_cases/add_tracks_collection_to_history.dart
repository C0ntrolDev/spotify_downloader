import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/domain.dart';

class AddTracksCollectionToHistory implements UseCase<Failure, void, TracksCollection> {
  AddTracksCollectionToHistory({required TracksCollectionsHistoryRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final TracksCollectionsHistoryRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, void>> call(TracksCollection tracksCollection) async {
    return await _historyPlaylistsRepository.addTracksCollectionToHistory(tracksCollection);
  }
}
