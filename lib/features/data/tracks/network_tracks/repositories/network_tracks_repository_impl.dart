import 'package:spotify_downloader/features/data/tracks/network_tracks/data_sources/network_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/repositories/converters/get_tracks_args_converter.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';

class NetworkTracksRepositoryImpl {
  NetworkTracksRepositoryImpl({required NetworkTracksDataSource networkTracksDataSource})
      : _networkTracksDataSource = networkTracksDataSource;

  final NetworkTracksDataSource _networkTracksDataSource;
  final GetTracksArgsConverter _getTracksArgsConverter = GetTracksArgsConverter();

  void getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args) {
    switch (args.tracksCollection.type) {
      case TracksCollectionType.playlist:
      _networkTracksDataSource.getTracksFromPlaylist(_getTracksArgsConverter.convert(args));
      case TracksCollectionType.album:
      _networkTracksDataSource.getTracksFromAlbum(_getTracksArgsConverter.convert(args));
      case TracksCollectionType.track:
      _networkTracksDataSource.getTrackBySpotifyId(_getTracksArgsConverter.convert(args));
      case TracksCollectionType.likedTracks:
        throw ArgumentError('can\'t load liked tracks using this method');
    }
  }
}
