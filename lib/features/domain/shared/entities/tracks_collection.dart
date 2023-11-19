import 'dart:core';
import 'package:equatable/equatable.dart';
import 'tracks_collection_type.dart';

class TracksCollection extends Equatable {
  const TracksCollection({
    required this.spotifyId, 
    required this.type, 
    required this.name, 
    this.smallImage, 
    this.bigImageUrl});

  final String spotifyId;
  final TracksCollectionType type;
  final String name;
  final String? smallImage;
  final String? bigImageUrl;

  @override
  List<Object?> get props => [spotifyId, type, name, smallImage, bigImageUrl];
}
