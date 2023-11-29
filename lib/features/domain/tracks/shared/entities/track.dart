import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

class Track {
  Track(
      {required this.spotifyId,
      required this.parentCollection,
      this.isLoaded = false,
      required this.name,
      this.youtubeUrl,
      this.artists,
      this.imageUrl});

  final String spotifyId;
  final String name;
  final TracksCollection parentCollection;

  String? youtubeUrl;
  bool isLoaded;

  final List<String>? artists;
  final String? imageUrl;
}
