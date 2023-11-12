import 'dart:ui';

class Video {

  Video({
    required this.url,
    required this.name,
    required this.autorName,
    required this.image,
    required this.views,
    required this.creationDate,
    required this.likes});

  final String url;
  final String name;
  final String autorName;
  final Image image;
  final int views;
  final DateTime creationDate;
  final int likes;
}
