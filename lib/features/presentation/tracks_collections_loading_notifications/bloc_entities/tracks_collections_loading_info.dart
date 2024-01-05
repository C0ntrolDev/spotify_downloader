import 'package:equatable/equatable.dart';

class TracksCollectionsLoadingInfo extends Equatable {
  final List<String> loadingTracksCollectionsNames;

  final int totalTracks;
  final int loadedTracks;
  final int loadingTracks;
  final int failuredTracks;

  const TracksCollectionsLoadingInfo(
      {required this.loadingTracksCollectionsNames,
      required this.totalTracks,
      required this.loadedTracks,
      required this.loadingTracks,
      required this.failuredTracks});

  @override
  List<Object?> get props => [loadingTracksCollectionsNames, totalTracks, loadedTracks, loadingTracks, failuredTracks];
}
