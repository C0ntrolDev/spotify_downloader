import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/network_tracks/models/tracks_dto_getting_ended_status.dart';

class TracksGettingStream {
  Function(Result<Failure, TracksDtoGettingEndedStatus>)? onEnded;
  Function(List<Track>)? onPartGot;
}