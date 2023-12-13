import 'package:spotify_downloader/features/domain/tracks/local_tracks/entities/local_tracks_collection.dart';

class LocalTrack {
    LocalTrack({
    required this.spotifyId,
    required this.isLoaded,
    required this.savePath,
    required this.tracksCollection,
    this.youtubeUrl
  });


  String spotifyId;
  bool isLoaded;
  String? youtubeUrl;
  String? savePath;
  LocalTracksCollection tracksCollection;
}