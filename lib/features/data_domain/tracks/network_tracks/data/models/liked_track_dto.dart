import 'package:spotify/spotify.dart';

class LikedTrackDto extends Track {
  final DateTime? addedAt;

  LikedTrackDto({required this.addedAt});
}