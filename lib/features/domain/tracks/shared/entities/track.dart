import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

class Track {
  Track(this.trackNumber,
      {required this.spotifyId,
      required this.parentCollection,
      this.isLoaded = false,
      this.name,
      this.youtubeUrl,
      this.artists,
      this.realiseYear,
      this.imageUrl});

  final String spotifyId;
  final TracksCollection parentCollection;

  String? youtubeUrl;
  bool isLoaded;

  final String? name;
  final List<String>? artists;
  final int? realiseYear;
  final String? imageUrl;
  final int? trackNumber;
}
