import 'dart:core';

import 'package:flutter/foundation.dart';

class Playlist {

  Playlist.withLocalImage({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    required this.image,
    this.imageUrl
  });

  Playlist.withImageUrl({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    this.image,
    required this.imageUrl
  });

  String spotifyId;
  String name;
  DateTime openDate;
  Uint8List? image;
  String? imageUrl;
  
}