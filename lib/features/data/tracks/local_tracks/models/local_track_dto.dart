import 'package:spotify_downloader/features/data/tracks/local_tracks/models/local_tracks_collection_dto.dart';

class LocalTrackDto {
  LocalTrackDto(
      {required this.spotifyId,
      required this.isLoaded,
      required this.savePath,
      required this.tracksCollection,
      this.youtubeUrl});

  String spotifyId;
  bool isLoaded;
  String? youtubeUrl;
  String? savePath;
  LocalTracksCollectionDto tracksCollection;
}
