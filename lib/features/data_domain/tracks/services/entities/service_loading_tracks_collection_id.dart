import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/entities/tracks_collection_type.dart';

class ServiceLoadingTracksCollectionId extends Equatable {
  final String spotifyId;
  final TracksCollectionType type;
  final String directoryPath;

  const ServiceLoadingTracksCollectionId({required this.spotifyId, required this.type, required this.directoryPath});

  @override
  List<Object> get props => [spotifyId, type, directoryPath];
}
