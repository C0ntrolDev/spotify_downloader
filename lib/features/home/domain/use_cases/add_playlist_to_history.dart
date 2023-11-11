import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_playlists_repository.dart';

class AddPlaylistToHistory implements UseCase<Failure, void, Playlist> {
  AddPlaylistToHistory({required HistoryPlaylistsRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  final HistoryPlaylistsRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, void>> call(Playlist playlist) async {
    return await _historyPlaylistsRepository.addPlaylistInHistory(playlist);
  }
}
