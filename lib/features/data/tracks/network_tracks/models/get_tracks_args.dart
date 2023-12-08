import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';

class GetTracksArgs {
  GetTracksArgs(
      {required this.spotifyId,
      required this.responseList,
      this.cancellationToken,
      this.firstCallbackLength = 50,
      this.callbackLength = 50,
      this.offset = 0});

  final String spotifyId;
  final List<Track> responseList;

  final CancellationToken? cancellationToken;

  final int firstCallbackLength;
  final int callbackLength;
  final int offset;
}
