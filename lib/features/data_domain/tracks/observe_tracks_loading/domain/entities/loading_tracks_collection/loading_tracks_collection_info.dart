import 'package:equatable/equatable.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/tracks_collection.dart';

class LoadingTracksCollectionInfo extends Equatable {
  const LoadingTracksCollectionInfo(
      {required this.totalTracks,
      required this.loadedTracks,
      required this.loadingTracks,
      required this.failuredTracks,
      required this.tracksCollection});

  const LoadingTracksCollectionInfo.empty()
      : totalTracks = 0,
        loadedTracks = 0,
        loadingTracks = 0,
        failuredTracks = 0,
        tracksCollection =  null;

  final int totalTracks;
  final int loadedTracks;
  final int loadingTracks;
  final int failuredTracks;

  final TracksCollection? tracksCollection;
  @override
  List<Object?> get props => [totalTracks, loadedTracks, loadingTracks, failuredTracks];
}
