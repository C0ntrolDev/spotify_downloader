import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_loading_ended_status.dart';

class GetTracksArgs {
  GetTracksArgs(
      {required this.spotifyId,
      required this.responseList,
      this.onLoadingEnded,
      this.onPartLoaded,
      this.cancellationToken,
      this.firstCallbackLength = 50,
      this.callbackLength = 50});

  final String spotifyId;
  final List<Track> responseList;

  final CancellationToken? cancellationToken;

  Function(Result<Failure, TracksDtoLoadingEndedStatus>)? onLoadingEnded;
  Function(List<Track>)? onPartLoaded;

  final int firstCallbackLength;
  final int callbackLength;
}
