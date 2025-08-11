import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/service_loading_tracks_collection_id.dart';

class ServiceLoadingTrackId extends Equatable {
  const ServiceLoadingTrackId({required this.parentCollectionId, required this.spotifyId});

  final ServiceLoadingTracksCollectionId parentCollectionId;
  final String spotifyId;

  @override
  List<Object?> get props => [parentCollectionId, spotifyId];
}
