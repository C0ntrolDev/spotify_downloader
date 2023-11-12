import 'dart:typed_data';

class LocalTracksCollection {

    LocalTracksCollection({
    required this.spotifyId,
    required this.type,
    required this.name,
    required this.openDate,
    this.image
  });

  
  String spotifyId;
  LocalPlaylistType type;
  String name;
  Uint8List? image;
  DateTime openDate;
}

enum LocalPlaylistType {
  likedTracks,
  playlist,
  album,
  track
}