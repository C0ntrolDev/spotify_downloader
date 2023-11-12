import 'dart:ffi';
import 'dart:typed_data';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/data_sources/local_tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/repositories/history_tracks_collections_repository.dart';
import 'package:spotify_downloader/features/data/models/local_playlist.dart';
import 'package:http/http.dart' as http;

class HistoryTracksCollectionsRepositoryImpl implements HistoryTracksCollectionsRepository {
  HistoryTracksCollectionsRepositoryImpl({required this.localTracksCollectionDataSource});

  LocalTracksCollectionsDataSource localTracksCollectionDataSource;

  @override
  Future<Result<Failure, void>> addPlaylistInHistory(TracksCollection playlist) async {
    try {
      await localTracksCollectionDataSource.addPlaylist(await _playlistToLocalPlaylist(playlist));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, void>> deletePlaylistFromHistory(TracksCollection trackCollection) async {
    try {
      await localTracksCollectionDataSource.deletePlaylist(await _playlistToLocalPlaylist(trackCollection));
      return const Result<Failure, void>.isSuccessful(Void);
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  @override
  Future<Result<Failure, List<TracksCollection>?>> getHistoryPlaylists() async {
    try {
      final historyTracksCollection = await localTracksCollectionDataSource.getLocalTracksCollections();

      if (historyTracksCollection != null) {
        return Result<Failure, List<TracksCollection>?>.isSuccessful(
            historyTracksCollection.map((lp) => _localPlaylistToPlaylist(lp)).toList());
      } else {
        return const Result.isSuccessful(null);
      }
    } catch (e) {
      return Result.notSuccessful(Failure(message: e));
    }
  }

  Future<LocalTracksCollection> _playlistToLocalPlaylist(TracksCollection tracksCollection) async {
    Uint8List? image;

    if (tracksCollection.image != null) {
      image = tracksCollection.image;
    }

    if (tracksCollection.imageUrl != null) {
      final response = await http.get(Uri.parse(tracksCollection.imageUrl!));

      if (response.statusCode == 200) {
        image = response.bodyBytes;
      }
    }

    return LocalTracksCollection(
        spotifyId: tracksCollection.spotifyId,
        type: LocalPlaylistType.values[tracksCollection.type.index],
        name: tracksCollection.name,
        openDate: tracksCollection.openDate,
        image: image);
  }

  TracksCollection _localPlaylistToPlaylist(LocalTracksCollection localTracksCollection) {
    return TracksCollection.withLocalImage(
        spotifyId: localTracksCollection.spotifyId,
        type: TracksCollectionType.values[localTracksCollection.type.index],
        name: localTracksCollection.name,
        openDate: localTracksCollection.openDate,
        image: localTracksCollection.image);
  }
}
