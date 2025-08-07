import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/tracks_collection_type.dart';

class TracksCollectionId extends Equatable{
  const TracksCollectionId({required this.spotifyId, required this.type});

  final String spotifyId;
  final TracksCollectionType type;

  static TracksCollectionId get likedTracksId => const TracksCollectionId(spotifyId: 'likedTracks', type: TracksCollectionType.likedTracks);

  @override
  List<Object> get props => [spotifyId, type];
}
