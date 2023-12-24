part of 'loading_tracks_collections_list_bloc.dart';

sealed class LoadingTracksCollectionsListState {
  const LoadingTracksCollectionsListState();
}

final class LoadingTracksCollectionsListInitial extends LoadingTracksCollectionsListState {}

final class LoadingTracksCollectionsListLoaded extends LoadingTracksCollectionsListState {
  const LoadingTracksCollectionsListLoaded({required this.loadingCollectionsObservers});

  final List<LoadingTracksCollectionObserver> loadingCollectionsObservers;
}

final class LoadingTracksCollectionsListFailure extends LoadingTracksCollectionsListState {
  const LoadingTracksCollectionsListFailure({required this.failure});

  final Failure? failure;
}
