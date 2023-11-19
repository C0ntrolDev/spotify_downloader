import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/domain/shared/track.dart';
import 'tracks_collection_type.dart';

class TracksCollection extends Equatable {
  const TracksCollection({
    required this.spotifyId, 
    required this.type, 
    required this.name,
    required this.tracks, 
    this.smallImage, 
    this.bigImageUrl});

  final String spotifyId;
  final TracksCollectionType type;
  final String name;
  final String? smallImage;
  final String? bigImageUrl;
  final List<Track> tracks;

  @override
  List<Object?> get props => [spotifyId, type, name, smallImage, bigImageUrl];
}
