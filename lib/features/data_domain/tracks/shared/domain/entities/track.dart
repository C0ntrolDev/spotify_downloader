import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/album.dart';

class Track {
  Track({
    required this.spotifyId,
    required this.parentCollection,
    required this.name,
    this.album,
    this.artists,
    this.duration,
    this.localYoutubeUrl,
    this.isLoaded = false,
  });

  final String spotifyId;
  final String name;
  final TracksCollection parentCollection;

  final Album? album;
  final List<String>? artists;
  final Duration? duration;

  final String? localYoutubeUrl;
  final bool isLoaded;
}
