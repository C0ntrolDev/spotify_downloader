import 'dart:ffi';

import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/use_case/use_case.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';
import 'package:spotify_downloader/features/home/domain/repositories/history_playlists_repository.dart';

class GetOrderedHistory implements UseCase<Failure, List<Playlist>?, Null> {
  GetOrderedHistory({required HistoryPlaylistsRepository historyPlaylistsRepository})
      : _historyPlaylistsRepository = historyPlaylistsRepository;

  HistoryPlaylistsRepository _historyPlaylistsRepository;

  @override
  Future<Result<Failure, List<Playlist>?>> call(Null params) async {
    final historyPlaylistsResult = await _historyPlaylistsRepository.getHistoryPlaylists();
    if (historyPlaylistsResult.isSuccessful) {
      historyPlaylistsResult.result?.sort((e1, e2) => e1.openDate.compareTo(e2.openDate));
    }
    return historyPlaylistsResult;
  }
}
