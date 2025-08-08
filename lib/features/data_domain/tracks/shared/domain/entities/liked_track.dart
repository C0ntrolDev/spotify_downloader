import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/entities.dart';

class LikedTrack extends Track {
  LikedTrack(
      {required super.spotifyId,
      required super.parentCollection,
      required super.name,
      super.album,
      super.albumTrackNumber,
      super.discNumber,
      super.artists,
      super.duration,
      super.localYoutubeUrl,
      super.isLoaded = false,
      required this.addedAt});

  final DateTime? addedAt;

  @override
  LikedTrack copyWith(
      {String? spotifyId,
      String? name,
      TracksCollection? parentCollection,
      ValueGetter<Album?>? album,
      ValueGetter<int?>? albumTrackNumber,
      ValueGetter<int?>? discNumber,
      ValueGetter<List<String>?>? artists,
      ValueGetter<Duration?>? duration,
      ValueGetter<String?>? localYoutubeUrl,
      bool? isLoaded,
      DateTime? addedAt}) {
    return LikedTrack(
        spotifyId: spotifyId ?? this.spotifyId,
        name: name ?? this.name,
        parentCollection: parentCollection ?? this.parentCollection,
        album: album != null ? album() : this.album,
        albumTrackNumber: albumTrackNumber != null ? albumTrackNumber() : this.albumTrackNumber,
        discNumber: discNumber != null ? discNumber() : this.discNumber,
        artists: artists != null ? artists() : this.artists,
        duration: duration != null ? duration() : this.duration,
        localYoutubeUrl: localYoutubeUrl != null ? localYoutubeUrl() : this.localYoutubeUrl,
        isLoaded: isLoaded ?? this.isLoaded,
        addedAt: addedAt ?? this.addedAt);
  }
}
