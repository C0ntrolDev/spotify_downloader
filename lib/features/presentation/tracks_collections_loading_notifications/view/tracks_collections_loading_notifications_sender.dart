import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/notifications/notifications.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/blocs/localization_cubit/localization_cubit.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/blocs/tracks_collections_loading_notifications_bloc/bloc/tracks_collections_loading_notifications_bloc.dart';
import 'package:spotify_downloader/features/presentation/tracks_collections_loading_notifications/blocs/tracks_collections_loading_notifications_bloc/bloc_entities/tracks_collections_loading_info.dart';
import 'package:spotify_downloader/l10n/app_localizations.dart';

class TracksCollectionsLoadingNotificationsSender {
  final LocalizationCubit _localizationCubit = injector.get<LocalizationCubit>();
  AppLocalizations? localization;

  final TracksCollectionsLoadingNotificationsBloc _bloc = injector.get<TracksCollectionsLoadingNotificationsBloc>();
  final int messageId = 10;

  TracksCollectionsLoadingInfo? updateWaitingInfo;
  bool isDelayEnded = true;

  TracksCollectionsLoadingNotificationsSender() {
    _bloc.add(TracksCollectionsLoadingNotificationsLoad());

    _localizationCubit.loadLanguage();
    subscribeToLocalizationUpdate();
  }

  void subscribeToLocalizationUpdate() {
    _localizationCubit.stream.listen((state) {
      if (state is LocalizationLoaded) {
        localization = state.localization;
      }
    });
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
    if (localization == null) {
      return;
    }

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
              title: localization!.allTracksAreLoaded,
              backgroundColor: primaryColor,
              body: localization!.allTracksAreLoadedBody(info.loadedTracks, info.failuredTracks),
              summary: '^_^',
              notificationLayout: NotificationLayout.Default,
              autoDismissible: false));
      return;
    }

    double progress = min((info.totalTracks - info.loadingTracks) / info.totalTracks, 1);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: messageId,
            channelKey: mainChannelKey,
            actionType: ActionType.Default,
            title: localization!.tracksAreBeingLoaded,
            backgroundColor: primaryColor,
            body: localization!
                .tracksAreBeingLoadedBody(info.totalTracks, info.loadedTracks, info.failuredTracks, progress),
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
