import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TracksCollection extends Equatable {

  const TracksCollection.withLocalImage({
    required this.spotifyId,
    required this.type,
    required this.name,
    required this.openDate,
    required this.image,
    this.imageUrl
  });

  const TracksCollection.withImageUrl({
    required this.spotifyId,
    required this.type,
    required this.name,
    required this.openDate,
    this.image,
    required this.imageUrl
  });

  final String spotifyId;
  final TracksCollectionType type;
  final String name;
  final DateTime openDate;
  final Uint8List? image;
  final String? imageUrl;
  

  @override
  List<Object?> get props => [spotifyId, name, openDate, image, imageUrl];
}

enum TracksCollectionType {
  likedTracks, 
  playlist,
  album,
  track
}