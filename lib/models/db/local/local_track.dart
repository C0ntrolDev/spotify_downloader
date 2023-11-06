class LocalTrack {
  
  LocalTrack({
    required this.spotifyId,
    required this.localPlaylistSpotifyId,
    this.isLoaded = false,
    this.youtubeUrl
  });

  LocalTrack.fromMap(Map<String, dynamic> map) :  
    spotifyId = map['spotifyId'], 
    localPlaylistSpotifyId = map['localPlaylist_spotifyId'],
    isLoaded = (map['isLoaded'] as int) == 1, 
    youtubeUrl = map['youtubeUrl'];


  String spotifyId;
  String localPlaylistSpotifyId;
  bool isLoaded;
  String? youtubeUrl;

  Map<String, dynamic> toMap() {
    return {
      'spotifyId': spotifyId,
      'localPlaylist_spotifyId' : localPlaylistSpotifyId,
      'isLoaded': isLoaded ? 1 : 0,
      'youtubeUrl': youtubeUrl,
    };
  }

}