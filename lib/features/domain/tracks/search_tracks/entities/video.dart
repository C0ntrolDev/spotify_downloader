class Video {
  const Video(
      {required this.url,
      required this.name,
      required this.thumbnailUrl,
      required this.likesCount,
      required this.autor});

  final String url;
  final String name;
  final String thumbnailUrl;
  final int likesCount;
  final String autor;
}
