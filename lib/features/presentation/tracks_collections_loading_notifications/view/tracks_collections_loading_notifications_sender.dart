import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/bloc/tracks_collections_loading_notifications_bloc.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/bloc_entities/tracks_collections_loading_info.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class TracksCollectionsLoadingNotificationsSender {
  final TracksCollectionsLoadingNotificationsBloc _bloc = injector.get<TracksCollectionsLoadingNotificationsBloc>();
  final int messageId = 10;

  TracksCollectionsLoadingInfo? updateWaitingInfo;
  bool isDelayEnded = true;

  TracksCollectionsLoadingNotificationsSender() {
    _bloc.add(TracksCollectionsLoadingNotificationsLoad());
  }

  Future<void> startSendNotifications() async {
    _bloc.stream.listen((state) {
      if (state is TracksCollectionsLoadingNotificationsChanged) {
        _onTracksCollectionsInfoChanged(state.info);
      }
    });
  }

  void _onTracksCollectionsInfoChanged(TracksCollectionsLoadingInfo newInfo) {
    if (isDelayEnded) {
      _sendNotification(newInfo);
      _startDelayedUpdate();
    } else {
      updateWaitingInfo = newInfo;
    }
  }

  void _sendNotification(TracksCollectionsLoadingInfo info) {
    if (info.totalTracks == 0) {
      AwesomeNotifications().cancel(messageId);
      return;
    }

    if (info.loadingTracks == 0) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: messageId,
              channelKey: mainChannelKey,
              actionType: ActionType.Default,
              title: S.current.allTracksAreLoaded,
              backgroundColor: primaryColor,
              body: S.current.allTracksAreLoadedBody(info.loadedTracks, info.failuredTracks),
              summary: '^_^',
              notificationLayout: NotificationLayout.Default,
              autoDismissible: false));
      return;
    }

    int progress = min(((info.totalTracks - info.loadingTracks) / info.totalTracks * 100).floor(), 100);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: messageId,
            channelKey: mainChannelKey,
            actionType: ActionType.SilentAction,
            title: S.current.tracksAreBeingLoaded,
            backgroundColor: primaryColor,
            body:
                S.current.tracksAreBeingLoadedBody(info.totalTracks, info.loadedTracks, info.failuredTracks, progress),
            summary: '^_^',
            autoDismissible: false,
            notificationLayout: NotificationLayout.ProgressBar,
            progress: progress == 0 ? null : progress));

  }

  void _startDelayedUpdate() {
    isDelayEnded = false;
    updateWaitingInfo = null;

    Future.delayed(const Duration(seconds: 1), () {
      if (updateWaitingInfo != null) {
        _sendNotification(updateWaitingInfo!);
        _startDelayedUpdate();
      } else {
        isDelayEnded = true;
      }
    });
  }
}
