import 'package:equatable/equatable.dart';

class Track extends Equatable {
    const Track({
    required this.isDownloaded,
    required this.spotifyId,
    required this.smallImageUrl,
    required this.bigImageUrl,
    required this.name,
    required this.autorsNames,
    this.youtubeUrl
  });


  final bool isDownloaded;
  final String? youtubeUrl;
  final String spotifyId;
  final String smallImageUrl;
  final String bigImageUrl;
  final String name;
  final List<String> autorsNames;

  @override
  List<Object?> get props => [isDownloaded, youtubeUrl, spotifyId, smallImageUrl, bigImageUrl, name, autorsNames];
}
