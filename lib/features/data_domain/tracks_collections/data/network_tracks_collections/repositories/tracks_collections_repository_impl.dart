import 'dart:async';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/converters/spotify_requests_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/data_source/network_tracks_collections_data_source.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/repositories/converters/album_dto_to_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/repositories/converters/playlist_dto_to_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/data/network_tracks_collections/repositories/converters/track_dto_to_tracks_collection_converter.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/spotify_repository_request.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/network_tracks_collections/repositories/network_tracks_collections_repository.dart';

class NetworkTracksCollectionsRepositoryImpl implements NetworkTracksCollectionsRepository {
  NetworkTracksCollectionsRepositoryImpl({required NetworkTracksCollectionsDataSource dataSource})
      : _dataSource = dataSource;

  final NetworkTracksCollectionsDataSource _dataSource;

  final SpotifyRequestsConverter _spotifyRequestsConverter = SpotifyRequestsConverter();

  final PlaylistDtoToTracksCollectionConverter _playlistDtoToTracksCollectionConverter =
      PlaylistDtoToTracksCollectionConverter();
  final TrackDtoToTracksCollectionConverter _trackDtoToTracksCollectionConverter =
      TrackDtoToTracksCollectionConverter();
  final AlbumDtoToTracksCollectionConverter _albumDtoToTracksCollectionConverter =
      AlbumDtoToTracksCollectionConverter();

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionByTypeAndSpotifyId(
      SpotifyRepositoryRequest spotifyRepositoryRequest, TracksCollectionType type, String spotifyId) async {
    switch (type) {
      case TracksCollectionType.playlist:
        final playlistResult = await _dataSource.getPlaylistBySpotifyId(
            _spotifyRequestsConverter.convert(spotifyRepositoryRequest), spotifyId);
        if (playlistResult.isSuccessful) {
          final convertedPlaylistResult = _playlistDtoToTracksCollectionConverter.convert(playlistResult.result!);
          return convertedPlaylistResult;
        } else {
          return Result.notSuccessful(playlistResult.failure);
        }
      case TracksCollectionType.album:
        final albumResult = await _dataSource.getAlbumBySpotifyId(
            _spotifyRequestsConverter.convert(spotifyRepositoryRequest), spotifyId);
        if (albumResult.isSuccessful) {
          final convertedAlbumResult = _albumDtoToTracksCollectionConverter.convert(albumResult.result!);
          return convertedAlbumResult;
        } else {
          return Result.notSuccessful(albumResult.failure);
        }
      case TracksCollectionType.track:
        final trackResult = await _dataSource.getTrackBySpotifyId(
            _spotifyRequestsConverter.convert(spotifyRepositoryRequest), spotifyId);
        if (trackResult.isSuccessful) {
          final convertedTrackResult = _trackDtoToTracksCollectionConverter.convert(trackResult.result!);
          return convertedTrackResult;
        } else {
          return Result.notSuccessful(trackResult.failure);
        }
      case TracksCollectionType.likedTracks:
        return Result.isSuccessful(TracksCollection.likedTracks);
    }
  }

  @override
  Future<Result<Failure, TracksCollection>> getTracksCollectionByUrl(
      SpotifyRepositoryRequest spotifyRepositoryRequest, String url) async {
    try {
      return getTracksCollectionByTypeAndSpotifyId(
          spotifyRepositoryRequest, _getTracksCollectionTypeFromUrl(url), _getSpotifyIdFromUrl(url));
    } catch (e) {
      return const Result.notSuccessful(NotFoundFailure());
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

    throw const NotFoundFailure();
  }

  String _getSpotifyIdFromUrl(String url) {
    return url.replaceAll('https://open.spotify.com/', '').split('/')[1].split('?')[0];
  }
}
