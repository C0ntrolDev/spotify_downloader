import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/network_tracks/models/tracks_dto_getting_ended_status.dart';

class TracksGettingStream {
  Function(Result<Failure, TracksDtoGettingEndedStatus>)? onEnded;
  Function(List<Track>)? onPartGot;
}