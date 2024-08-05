import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/data/models/tracks_dto_getting_ended_status.dart';

class TracksGettingStream {
  Function(Result<Failure, TracksDtoGettingEndedStatus>)? onEnded;
  Function(List<Track>)? onPartGot;
}