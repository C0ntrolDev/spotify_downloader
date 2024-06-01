import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/features/data_domain/shared/data/spotify_api_request.dart';

class GetTracksArgs {
  GetTracksArgs(
      {required this.spotifyApiRequest,
      required this.spotifyId,
      required this.responseList,
      this.cancellationToken,
      this.firstCallbackLength = 50,
      this.callbackLength = 50,
      this.offset = 0});

  final SpotifyApiRequest spotifyApiRequest;

  final String spotifyId;
  final List<Track> responseList;

  final CancellationToken? cancellationToken;

  final int firstCallbackLength;
  final int callbackLength;
  final int offset;
}
