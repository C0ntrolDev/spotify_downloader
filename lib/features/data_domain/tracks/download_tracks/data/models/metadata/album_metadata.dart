class AlbumMetadata {
  AlbumMetadata({
    this.name,
    this.imageUrl,
    this.artists,
    this.totalTracksCount
  });

  final String? name;
  final String? imageUrl;
  final List<String>? artists;
  final int? totalTracksCount;
}
