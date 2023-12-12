class HistoryTracksCollectionDTO {

  HistoryTracksCollectionDTO({
    required this.spotifyId,
    required this.name,
    required this.type,
    this.imageUrl,
    required this.openDate
  });

  String spotifyId;
  String name;
  HistoryTracksCollectionType type;
  String? imageUrl;
  DateTime openDate;
}

enum HistoryTracksCollectionType {
  likedTracks, 
  playlist,
  album,
  track
}