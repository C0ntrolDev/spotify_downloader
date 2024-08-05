part of 'loading_tracks_collections_list_cubit.dart';

sealed class LoadingTracksCollectionsListState {
  const LoadingTracksCollectionsListState();
}

final class LoadingTracksCollectionsListInitial extends LoadingTracksCollectionsListState {}

final class LoadingTracksCollectionsListLoaded extends LoadingTracksCollectionsListState {
  final List<LoadingTracksCollectionObserver> loadingCollectionsObservers;

  const LoadingTracksCollectionsListLoaded({required this.loadingCollectionsObservers});
}

final class LoadingTracksCollectionsListFailure extends LoadingTracksCollectionsListState {
  const LoadingTracksCollectionsListFailure({required this.failure});

  final Failure? failure;
}
