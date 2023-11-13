import 'dart:typed_data';

class HistoryTracksCollection {

  HistoryTracksCollection({
    required this.spotifyId,
    required this.name,
    required this.type,
    this.image,
    required this.openDate
  });

  String spotifyId;
  String name;
  HistoryTracksCollectionType type;
  Uint8List? image;
  DateTime openDate;
}

enum HistoryTracksCollectionType {
  likedTracks, 
  playlist,
  album,
  track
}