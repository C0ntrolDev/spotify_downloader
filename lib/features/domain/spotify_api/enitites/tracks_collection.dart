import 'dart:core';
import 'package:equatable/equatable.dart';
import '../../shared/entities/tracks_collection_type.dart';

class TracksCollection extends Equatable {
  const TracksCollection({
    required this.spotifyId, 
    required this.type, 
    required this.name,
    this.smallImageUrl, 
    this.bigImageUrl});

  final String spotifyId;
  final TracksCollectionType type;
  final String name;
  final String? smallImageUrl;
  final String? bigImageUrl;

  @override
  List<Object?> get props => [spotifyId, type, name, smallImageUrl, bigImageUrl];
}
