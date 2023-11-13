import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TracksCollection extends Equatable {

  const TracksCollection.withLocalImage({
    required this.spotifyId,
    required this.type,
    required this.name,
    this.openDate,
    required this.image,
    this.imageUrl
  });

  const TracksCollection.withImageUrl({
    required this.spotifyId,
    required this.type,
    required this.name,
    this.openDate,
    this.image,
    required this.imageUrl
  });

  final String spotifyId;
  final TracksCollectionType type;
  final DateTime? openDate;
  final String name;
  final Uint8List? image;
  final String? imageUrl;
  

  @override
  List<Object?> get props => [spotifyId, name, type, image, openDate, imageUrl];
}

enum TracksCollectionType {
  likedTracks, 
  playlist,
  album,
  track
}