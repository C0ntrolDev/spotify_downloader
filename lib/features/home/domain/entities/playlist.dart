import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Playlist extends Equatable {

  const Playlist.withLocalImage({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    required this.image,
    this.imageUrl
  });

  const Playlist.withImageUrl({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    this.image,
    required this.imageUrl
  });

  final String spotifyId;
  final String name;
  final DateTime openDate;
  final Uint8List? image;
  final String? imageUrl;
  

  @override
  List<Object?> get props => [spotifyId, name, openDate, image, imageUrl];
}