import 'package:spotify_downloader/features/data_domain/tracks/local_tracks/data/models/local_tracks_collection_dto.dart';

class LocalTrackDto {
  LocalTrackDto(
      {required this.spotifyId,
      required this.savePath,
      required this.tracksCollection,
      required this.youtubeUrl});

  String spotifyId;
  String youtubeUrl;
  String savePath;
  LocalTracksCollectionDto tracksCollection;
}
