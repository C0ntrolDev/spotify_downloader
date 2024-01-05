part of 'loading_tracks_collection_tile_cubit.dart';

sealed class LoadingTracksCollectionTileState extends Equatable {
  const LoadingTracksCollectionTileState();

  @override
  List<Object> get props => [];
}

final class LoadingTracksCollectionTileChanged extends LoadingTracksCollectionTileState {
  const LoadingTracksCollectionTileChanged({required this.loadingTrackInfo});
  final LoadingTracksCollectionInfo loadingTrackInfo;

  @override
  List<Object> get props => [loadingTrackInfo];
}
