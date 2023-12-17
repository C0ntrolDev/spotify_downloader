import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.url,
    required this.title,
    required this.thumbnailUrl,
    required this.viewsCount,
    required this.author,
    this.duration,
  });

  final String url;
  final String title;
  final String thumbnailUrl;
  final int viewsCount;
  final String author;
  final Duration? duration;

  @override
  List<Object?> get props => [url];
}
