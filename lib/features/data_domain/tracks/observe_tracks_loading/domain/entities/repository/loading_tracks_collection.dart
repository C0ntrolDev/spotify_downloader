import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/entities.dart';

class LoadingTracksCollection {
  LoadingTracksCollection({required this.id, required this.controller});

  final LoadingTracksCollectionId id;
  final LoadingTracksCollectionController controller;
}
