import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';

class LoadingTrackId extends Equatable {
  const LoadingTrackId({required this.parentSpotifyId, required this.parentType, required this.spotifyId, required this.savePath});

  final String parentSpotifyId;
  final TracksCollectionType parentType;
  final String savePath;
  final String spotifyId;

  @override
  List<Object?> get props => [parentSpotifyId, parentType, savePath, spotifyId];
}
