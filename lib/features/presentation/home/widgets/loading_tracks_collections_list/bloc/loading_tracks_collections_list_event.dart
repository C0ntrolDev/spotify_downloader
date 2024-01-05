part of 'loading_tracks_collections_list_bloc.dart';

sealed class LoadingTracksCollectionsListEvent extends Equatable {
  const LoadingTracksCollectionsListEvent();

  @override
  List<Object> get props => [];
}

final class LoadingTracksCollectionsListLoad extends LoadingTracksCollectionsListEvent {}

final class LoadingTracksCollectionsListUpdate extends LoadingTracksCollectionsListEvent {
  final List<LoadingTracksCollectionObserver> loadingCollectionsObservers;

  const LoadingTracksCollectionsListUpdate({required this.loadingCollectionsObservers});
}
