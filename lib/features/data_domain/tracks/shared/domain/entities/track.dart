import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/album.dart';

class Track {
  Track(
      {required this.spotifyId,
      required this.name,
      this.album,
      this.albumTrackNumber,
      this.discNumber,
      this.artists,
      this.duration});

  final String spotifyId;
  final String name;
  final Album? album;

  final int? albumTrackNumber;
  final int? discNumber;

  final List<String>? artists;
  final Duration? duration;

  Track copyWith(
      {String? spotifyId,
      String? name,
      ValueGetter<Album?>? album,
      ValueGetter<int?>? albumTrackNumber,
      ValueGetter<int?>? discNumber,
      ValueGetter<List<String>?>? artists,
      ValueGetter<Duration?>? duration,
      ValueGetter<String?>? localYoutubeUrl,
      bool? isLoaded}) {
    return Track(
        spotifyId: spotifyId ?? this.spotifyId,
        name: name ?? this.name,
        album: album != null ? album() : this.album,
        albumTrackNumber: albumTrackNumber != null ? albumTrackNumber() : this.albumTrackNumber,
        discNumber: discNumber != null ? discNumber() : this.discNumber,
        artists: artists != null ? artists() : this.artists,
        duration: duration != null ? duration() : this.duration);
  }
}
