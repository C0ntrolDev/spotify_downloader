import 'package:flutter/material.dart';
import 'album_metadata.dart';

class AudioMetadata {
  final String name;
  final List<String>? artists;
  final int? realiseYear;
  final AlbumMetadata? album;
  final int? trackNumber;
  final int? discNumber;

  final double? durationMs;

  AudioMetadata(
      {required this.name,
      this.artists,
      this.realiseYear,
      this.album,
      this.trackNumber,
      this.discNumber,
      this.durationMs});

  AudioMetadata copyWith(
      {String? name,
      ValueGetter<List<String>?>? artists,
      ValueGetter<int?>? realiseYear,
      ValueGetter<AlbumMetadata?>? album,
      ValueGetter<int?>? trackNumber,
      ValueGetter<int?>? discNumber,
      ValueGetter<double?>? durationMs}) {
    return AudioMetadata(
        name: name ?? this.name,
        artists: artists != null ? artists() : this.artists,
        realiseYear: realiseYear != null ? realiseYear() : this.realiseYear,
        album: album != null ? album() : this.album,
        trackNumber: trackNumber != null ? trackNumber() : this.trackNumber,
        discNumber: discNumber != null ? discNumber() : this.discNumber,
        durationMs: durationMs != null ? durationMs() : this.durationMs);
  }
}
