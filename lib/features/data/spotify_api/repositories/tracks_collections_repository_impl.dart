import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/spotify_api/data_source/tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/repositories/tracks_collections_repository.dart';

class TracksCollectionsRepositoryImpl implements TracksCollectionsRepository {
  TracksCollectionsRepositoryImpl({required TracksCollectionsDataSource dataSource}) : _dataSource = dataSource;

  TracksCollectionsDataSource _dataSource;

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      TracksCollectionType type, String spotifyId) async {
    final result = await _dataSource.getPlaylistBySpotifyId(spotifyId);
    if (result.isSuccessful) {
      return Result.isSuccessful(TracksCollection(
          spotifyId: spotifyId,
          type: type,
          name: result.result!.name ?? '',
          bigImageUrl: result.result!.images!.last.url,
          smallImageUrl: result.result!.images!.first.url));
    }

    return Result.notSuccessful(result.failure);
  }

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(String url) async {
    try {
      return getTracksCollectionByTypeAndSpotifyId(_getTracksCollectionTypeFromUrl(url), _getSpotifyIdFromUrl(url));
    } catch (e) {
      return Result.notSuccessful(NotFoundFailure());
    }
  }

  TracksCollectionType _getTracksCollectionTypeFromUrl(String url) {
    if (url.contains('track')) {
      return TracksCollectionType.track;
    }

    if (url.contains('playlist')) {
      return TracksCollectionType.playlist;
    }

    if (url.contains('album')) {
      return TracksCollectionType.album;
    }

    throw NotFoundFailure();
  }

  String _getSpotifyIdFromUrl(String url) {
    return url.replaceAll('https://open.spotify.com/', '').split('/')[1].split('?')[0];
  }
}
