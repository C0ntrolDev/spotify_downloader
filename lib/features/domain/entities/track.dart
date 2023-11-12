class Track {
  Track({
    required this.isDownloaded,
    required this.youtubeUrl,
    required this.spotifyId,
    required this.smallImageUrl,
    required this.bigImageUrl,
    required this.name,
    required this.autorsNames});

  bool isDownloaded;
  String? youtubeUrl;
  String spotifyId;
  String smallImageUrl;
  String bigImageUrl;
  String name;
  List<String> autorsNames;
}
