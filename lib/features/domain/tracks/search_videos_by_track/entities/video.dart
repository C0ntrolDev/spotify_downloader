class Video {
  const Video(
      {required this.url,
      required this.title,
      required this.thumbnailUrl,
      required this.likesCount,
      required this.author});

  final String url;
  final String title;
  final String thumbnailUrl;
  final int? likesCount;
  final String author;
}
