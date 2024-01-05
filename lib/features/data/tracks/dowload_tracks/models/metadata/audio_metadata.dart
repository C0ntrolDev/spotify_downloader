import 'album_metadata.dart';

class AudioMetadata {
  AudioMetadata(
      {required this.name,
      this.artists,
      this.realiseYear,
      this.album,
      this.trackNumber,
      this.durationMs});

  final String name;
  final List<String>? artists;
  final int? realiseYear;
  final AlbumMetadata? album;
  final int? trackNumber;
  final double? durationMs;

  AudioMetadata copyWith(
      {String? name,
      String? imageUrl,
      List<String>? artists,
      int? realiseYear,
      AlbumMetadata? album,
      int? trackNumber,
      double? durationMs}) {
    return AudioMetadata(
        name: name ?? this.name,
        artists: artists ?? this.artists,
        realiseYear: realiseYear ?? this.realiseYear,
        album: album ?? this.album,
        trackNumber: this.trackNumber);
  }
}
