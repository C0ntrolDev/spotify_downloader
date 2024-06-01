import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/album.dart';

class Track {
  Track(
      {required this.spotifyId,
      required this.parentCollection,
      this.isLoaded = false,
      required this.name,
      this.album,
      this.youtubeUrl,
      this.artists,
      this.duration});

  final String spotifyId;
  final String name;
  final TracksCollection parentCollection;

  String? youtubeUrl;
  bool isLoaded;

  final Album? album;
  final List<String>? artists;
  final Duration? duration;
}