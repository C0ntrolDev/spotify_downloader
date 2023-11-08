import 'dart:typed_data';

class LocalPlaylist {

  LocalPlaylist({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    this.image
  });
  
  String spotifyId;
  String name;
  Uint8List? image;
  DateTime openDate;
}