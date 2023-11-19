import 'package:spotify_downloader/features/domain/entities/track.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';

class GetTracksGraduallyArgs {
  
  GetTracksGraduallyArgs({
    required this.tracksCollection,
    required this.recipientList,
    this.onChanged,
    this.onLoadEnded
  });

  final TracksCollection tracksCollection;
  final List<Track> recipientList;
  final Function? onChanged;
  final Function? onLoadEnded;
}