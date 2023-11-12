import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/home/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_tracks_collections_repository.dart';

class AddTracksCollectionToHistory implements UseCase<Failure, void, TracksCollection> {
  AddTracksCollectionToHistory({required HistoryTracksCollectionsRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final HistoryTracksCollectionsRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, void>> call(TracksCollection playlist) async {
    return await _historyPlaylistsRepository.addPlaylistInHistory(playlist);
  }
}
