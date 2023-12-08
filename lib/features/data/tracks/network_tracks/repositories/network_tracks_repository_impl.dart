import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/data_sources/network_tracks_data_source.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_getting_ended_status.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_getting_stream.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/repositories/converters/track_dto_to_track_converter.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection_type.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_controller.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify/spotify.dart' as dto;
import 'package:spotify_downloader/features/domain/tracks/network_tracks/repositories/network_tracks_repository.dart';

class NetworkTracksRepositoryImpl implements NetworkTracksRepository {
  NetworkTracksRepositoryImpl({
    required NetworkTracksDataSource networkTracksDataSource,
  }) : _networkTracksDataSource = networkTracksDataSource;

  final NetworkTracksDataSource _networkTracksDataSource;
  final TrackDtoToTrackConverter _trackDtoToTrackConverter = TrackDtoToTrackConverter();

  @override
  Future<TracksGettingController> getTracksFromTracksCollection(GetTracksFromTracksCollectionArgs args) async {
    final responseList = List<dto.Track>.empty(growable: true);
    final cancellationTokenSource = CancellationTokenSource();
    final getTracksArgs = GetTracksArgs(
        spotifyId: args.tracksCollection.spotifyId,
        responseList: responseList,
        cancellationToken: cancellationTokenSource.token,
        offset: args.offset,
        firstCallbackLength: 200,
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
        throw ArgumentError('can\'t load liked tracks using this method');
    }

    final controller = _getLinkedToStreamController(tracksGettingStream, args);
    return controller;
  }

  TracksGettingController _getLinkedToStreamController(
      TracksGettingStream tracksGettingStream, GetTracksFromTracksCollectionArgs args) {
    final controller = TracksGettingController(cancelGetting: () {});

    tracksGettingStream.onEnded = (result) => controller.onEnded?.call(result.isSuccessful
        ? Result.isSuccessful(_convertDtoStatusToStatus(result.result!))
        : Result.notSuccessful(result.failure));
    tracksGettingStream.onPartGot = (dtoTracksPart) {
      final tracksPart = dtoTracksPart.map((dt) => _trackDtoToTrackConverter.convert((dt, args.tracksCollection)));
      args.responseList.addAll(tracksPart);
      controller.onPartGot?.call(tracksPart);
    };

    return controller;
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
