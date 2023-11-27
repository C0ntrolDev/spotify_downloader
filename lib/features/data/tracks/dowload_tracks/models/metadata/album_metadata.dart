class AlbumMetadata {
  AlbumMetadata({required this.name, this.artists, this.totalTracksCount});

  final String name;
  final List<String>? artists;
  final int? totalTracksCount;
}
