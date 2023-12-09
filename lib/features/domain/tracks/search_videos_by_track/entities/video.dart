class Video {
    Video({
    required this.url,
    required this.title,
    required this.thumbnailUrl,
    required this.author,
    this.duration,
    this.likesCount
  });


  final String url;
  final String title;
  final String thumbnailUrl;
  final int? likesCount;
  final String author;
  final Duration? duration;
}
