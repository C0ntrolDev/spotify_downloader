import 'package:spotify/spotify.dart';
import 'package:spotify_downloader/models/db/local/local_track.dart';

class FullTrack {
  FullTrack({
    required this.localTrack,
    required this.track
  });
  
  LocalTrack localTrack;
  Track track;
}