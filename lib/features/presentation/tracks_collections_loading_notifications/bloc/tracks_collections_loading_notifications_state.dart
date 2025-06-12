part of 'tracks_collections_loading_notifications_bloc.dart';

sealed class TracksCollectionsLoadingNotificationsState extends Equatable {
  const TracksCollectionsLoadingNotificationsState();

  @override
  List<Object?> get props => [];
}

final class TracksCollectionsLoadingNotificationInitial extends TracksCollectionsLoadingNotificationsState {}

final class TracksCollectionsLoadingNotificationFailure extends TracksCollectionsLoadingNotificationsState {
  final Failure? failure;

  const TracksCollectionsLoadingNotificationFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class TracksCollectionsLoadingNotificationsChanged extends TracksCollectionsLoadingNotificationsState {
  final TracksCollectionsLoadingInfo info;

  const TracksCollectionsLoadingNotificationsChanged({required this.info});

  @override
  List<Object?> get props => [info];
}
