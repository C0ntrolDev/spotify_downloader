import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/get_tracks_args.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_loading_ended_status.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/repositories/converters/track_dto_to_track_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/get_tracks_from_tracks_collection_args.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_loading_ended_status.dart';

class GetTracksArgsConverter implements ValueConverter<GetTracksArgs, GetTracksFromTracksCollectionArgs> {
  final _trackDtoToTrackConverter = TrackDtoToTrackConverter();

  @override
  GetTracksArgs convert(GetTracksFromTracksCollectionArgs args) {
    return GetTracksArgs(
        spotifyId: args.tracksCollection.spotifyId,
        responseList: List.empty(),
        cancellationToken: args.cancellationToken,
        onPartLoaded: (part) {
          for (var trackDto in part) {
            args.responseList.add(_trackDtoToTrackConverter.convert((trackDto, args.tracksCollection)));
          }
          args.onPartLoaded;
        },
        onLoadingEnded: (result) {
          if (!result.isSuccessful) {
            args.onLoadingEnded?.call(Result.notSuccessful(result.failure));
          } else {
            args.onLoadingEnded?.call(Result.isSuccessful(result.result! == TracksDtoLoadingEndedStatus.loaded
                ? TracksLoadingEndedStatus.loaded
                : TracksLoadingEndedStatus.cancelled));
          }
        },
        callbackLength: 50,
        firstCallbackLength: 200);
  }

  @override
  GetTracksFromTracksCollectionArgs convertBack(GetTracksArgs value) {
    throw UnimplementedError();
  }
}
