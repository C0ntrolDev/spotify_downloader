import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

class LikedTrack extends Track {
  LikedTrack(
      {required super.spotifyId,
      required super.parentCollection,
      required super.name,
      super.album,
      super.artists,
      super.duration,
      super.localYoutubeUrl,
      super.isLoaded = false,
      required this.addedAt});

  final DateTime? addedAt;
}
