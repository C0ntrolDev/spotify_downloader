import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video(
      {required this.url,
      required this.title,
      required this.thumbnailUrl,
      required this.author,
      this.duration,
      this.likesCount});

  final String url;
  final String title;
  final String thumbnailUrl;
  final int? likesCount;
  final String author;
  final Duration? duration;

  @override
  List<Object?> get props => [url, title, thumbnailUrl, likesCount, author, duration];
}
