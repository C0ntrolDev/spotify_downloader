import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/repositories/history_tracks_collections_repository.dart';

class GetOrderedHistory implements UseCase<Failure, List<TracksCollection>?, Null> {
  GetOrderedHistory({required HistoryTracksCollectionsRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final HistoryTracksCollectionsRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, List<TracksCollection>?>> call(Null params) async {
    final historyPlaylistsResult = await _historyPlaylistsRepository.getHistoryPlaylists();
    if (historyPlaylistsResult.isSuccessful) {
      historyPlaylistsResult.result?.sort((e1, e2) => e1.openDate.compareTo(e2.openDate));
    }
    return historyPlaylistsResult;
  }
}
