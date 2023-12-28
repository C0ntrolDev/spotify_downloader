part of 'tracks_collections_loading_notifications_bloc.dart';

sealed class TracksCollectionsLoadingNotificationsEvent extends Equatable {
  const TracksCollectionsLoadingNotificationsEvent();

  @override
  List<Object> get props => [];
}

final class TracksCollectionsLoadingNotificationsLoad extends TracksCollectionsLoadingNotificationsEvent {}

final class TracksCollectionsLoadingNotificationsUpdate extends TracksCollectionsLoadingNotificationsEvent {}
