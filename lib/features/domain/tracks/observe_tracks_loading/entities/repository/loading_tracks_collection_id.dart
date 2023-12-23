import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection_type.dart';

class LoadingTracksCollectionId extends Equatable {
  const LoadingTracksCollectionId({required this.spotifyId, required this.tracksCollectionType});

  final String spotifyId;
  final TracksCollectionType tracksCollectionType;

  @override
  List<Object?> get props => [spotifyId, tracksCollectionType];
}
