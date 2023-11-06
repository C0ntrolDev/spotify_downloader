import 'dart:typed_data';
import 'package:spotify_downloader/models/db/local/local_track.dart';
import 'package:http/http.dart' as http;

class LocalPlaylist {

  LocalPlaylist({
    required this.spotifyId,
    required this.name,
    required this.openDate,
    this.image,
    this.localTracks
  });

  LocalPlaylist.fromMap(Map<String, dynamic> map) :
    spotifyId = map['spotifyId'],
    name = map['name'],
    image = map['image'],
    openDate = DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int);
  

  static Future<LocalPlaylist> createUsingUrl({
    required String spotifyId,
    required String name,
    required DateTime openDate,
    required String imageUrl,
    List<LocalTrack>? localTracks
  }) async
  {
    final response = await http.get(Uri.parse(imageUrl));
    Uint8List? image;

    if (response.statusCode == 200) {
      image = response.bodyBytes;
    }
    else {
      image = null;
    }

    return LocalPlaylist(
      spotifyId: spotifyId, 
      name: name, 
      openDate: openDate,
      image: image,
      localTracks: localTracks);
  }

  String spotifyId;
  String name;
  Uint8List? image;
  DateTime openDate;
  List<LocalTrack>? localTracks;

  Map<String, dynamic> toMap() {
    return {
      'spotifyId':spotifyId,
      'name': name,
      'openDate' : openDate.millisecondsSinceEpoch,
      'image': image,
    };
  }
}