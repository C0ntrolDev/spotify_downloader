import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';

class LocalTrack {
    LocalTrack({
    required this.spotifyId,
    required this.savePath,
    required this.tracksCollection,
    required this.youtubeUrl
  });


  String spotifyId;
  String youtubeUrl;
  String savePath;
  LocalTracksCollection tracksCollection;
}