import 'dart:core';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/shared/domain/entities/base_tracks_collection.dart';

class TracksCollection extends BaseTracksCollection {
  const TracksCollection(
      {required super.name, required super.id, this.tracksCount, this.artists, this.smallImageUrl, super.imageUrl});

  final int? tracksCount;
  final List<String>? artists;
  final String? smallImageUrl;

  @override
  List<Object?> get props => [id, name, artists, smallImageUrl, imageUrl];

  static TracksCollection likedTracks(int tracksCount) => TracksCollection(
      id: TracksCollectionId.likedTracksId,
      tracksCount: tracksCount,
      name: 'Liked Tracks',
      artists: const ['^_^'],
      smallImageUrl: 'https://misc.scdn.co/liked-songs/liked-songs-300.png',
      imageUrl: 'https://misc.scdn.co/liked-songs/liked-songs-640.png');
}
