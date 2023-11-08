import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_playlists_repository.dart';

class GetOrderedHistory implements UseCase<Failure, void, List<Playlist>?> {
  GetOrderedHistory({required this.historyPlaylistsRepository});

  HistoryPlaylistsRepository historyPlaylistsRepository;

  @override
  Future<Result<Failure, void>> call(List<Playlist>? params) async {
    final historyPlaylistsResult =  await historyPlaylistsRepository.getHistoryPlaylists();
    if (historyPlaylistsResult.isSuccessful) {
      historyPlaylistsResult.result!.sort((e1, e2) => e1.openDate.compareTo(e2.openDate));
    }
    return historyPlaylistsResult;
  }
}
