import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_loading_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class GetTracksFromTracksCollectionArgs {
  GetTracksFromTracksCollectionArgs(
      {required this.tracksCollection,
      required this.responseList,
      this.onLoadingEnded,
      this.onPartLoaded,
      this.cancellationToken});

  final TracksCollection tracksCollection;
  final List<Track?> responseList;

  final Function(Result<Failure, TracksLoadingEndedStatus>)? onLoadingEnded;
  final Function? onPartLoaded;
  final CancellationToken? cancellationToken;
}
