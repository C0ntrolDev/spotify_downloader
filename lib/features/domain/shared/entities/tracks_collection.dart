import 'dart:core';
import 'package:equatable/equatable.dart';
import 'tracks_collection_type.dart';

class TracksCollection extends Equatable {
  const TracksCollection(
      {required this.spotifyId,
      required this.type,
      required this.name,
      required this.tracksCount,
      this.artists,
      this.smallImageUrl,
      this.bigImageUrl});

  final String spotifyId;
  final TracksCollectionType type;
  final String name;
  final int tracksCount;
  final List<String>? artists;
  final String? smallImageUrl;
  final String? bigImageUrl;

  @override
  List<Object?> get props => [spotifyId, type, name, tracksCount, artists, smallImageUrl, bigImageUrl];
}
