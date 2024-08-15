import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/album.dart';

class Track {
  Track(
      {required this.spotifyId,
      required this.name,
      required this.parentCollection,
      this.isLoaded = false,
      this.album,
      this.albumTrackNumber,
      this.discNumber,
      this.artists,
      this.duration,
      this.localYoutubeUrl});

  final String spotifyId;
  final String name;
  final TracksCollection parentCollection;

  final Album? album;

  final int? albumTrackNumber;
  final int? discNumber;

  final List<String>? artists;
  final Duration? duration;

  final String? localYoutubeUrl;
  final bool isLoaded;

  Track copyWith(
      {String? spotifyId,
      String? name,
      TracksCollection? parentCollection,
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
        parentCollection: parentCollection ?? this.parentCollection,
        album: album != null ? album() : this.album,
        albumTrackNumber: albumTrackNumber != null ? albumTrackNumber() : this.albumTrackNumber,
        discNumber: discNumber != null ? discNumber() : this.discNumber,
        artists: artists != null ? artists() : this.artists,
        duration: duration != null ? duration() : this.duration,
        localYoutubeUrl: localYoutubeUrl != null ? localYoutubeUrl() : this.localYoutubeUrl,
        isLoaded: isLoaded ?? this.isLoaded);
  }
}
