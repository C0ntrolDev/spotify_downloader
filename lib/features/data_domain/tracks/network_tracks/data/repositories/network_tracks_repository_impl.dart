import 'package:spotify/spotify.dart' as dto;
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/converters/spotify_requests_converter.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/network_tracks.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';


class NetworkTracksRepositoryImpl implements NetworkTracksRepository {
  NetworkTracksRepositoryImpl({
    required NetworkTracksDataSource networkTracksDataSource,
  }) : _networkTracksDataSource = networkTracksDataSource;

  final NetworkTracksDataSource _networkTracksDataSource;
  final TrackDtoToTrackConverter _trackDtoToTrackConverter = TrackDtoToTrackConverter();
  final SpotifyRequestsConverter _spotifyRequestsConverter = SpotifyRequestsConverter();

  @override
  Future<TracksGettingObserver> getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args) async {
    final responseList = List<dto.Track>.empty(growable: true);
    final getTracksArgs = GetTracksArgs(
        spotifyApiRequest: _spotifyRequestsConverter.convert(args.spotifyRepositoryRequest),
        spotifyId: args.tracksCollection.spotifyId,
        responseList: responseList,
        offset: args.offset,
        firstCallbackLength: 50,
        callbackLength: 50);

    final TracksGettingStream tracksGettingStream;

    switch (args.tracksCollection.type) {
      case TracksCollectionType.playlist:
        tracksGettingStream = await _networkTracksDataSource.getTracksFromPlaylist(getTracksArgs);
      case TracksCollectionType.album:
        tracksGettingStream = await _networkTracksDataSource.getTracksFromAlbum(getTracksArgs);
      case TracksCollectionType.track:
        tracksGettingStream = _networkTracksDataSource.getTrackBySpotifyId(getTracksArgs);
      case TracksCollectionType.likedTracks:
         tracksGettingStream = await _networkTracksDataSource.getLikedTracks(getTracksArgs);
    }

    final observer = _getLinkedToStreamObserver(tracksGettingStream, args);
    return observer;
  }

  TracksGettingObserver _getLinkedToStreamObserver(
      TracksGettingStream tracksGettingStream, GetTracksFromTracksCollectionArgs args) {
    final observer = TracksGettingObserver();

    tracksGettingStream.onEnded = (result) {
      observer.onEnded?.call(result.isSuccessful
          ? Result.isSuccessful(_convertDtoStatusToStatus(result.result!))
          : Result.notSuccessful(result.failure));
    };
    tracksGettingStream.onPartGot = (dtoTracksPart) {
      final tracksPart = dtoTracksPart.map((dt) => _trackDtoToTrackConverter.convert((dt, args.tracksCollection)));
      observer.onPartGot?.call(tracksPart);
    };

    return observer;
  }

  TracksGettingEndedStatus _convertDtoStatusToStatus(TracksDtoGettingEndedStatus dtoStatus) {
    switch (dtoStatus) {
      case TracksDtoGettingEndedStatus.loaded:
        return TracksGettingEndedStatus.loaded;
      case TracksDtoGettingEndedStatus.cancelled:
        return TracksGettingEndedStatus.cancelled;
    }
  }
}
