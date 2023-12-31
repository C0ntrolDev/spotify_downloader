import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

const String mainChannelKey = 'main_channel';

Future<void> initAwesomeNotifications() async {
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'main_channel_group',
            channelKey: 'main_channel',
            channelName: 'Main notifications',
            channelDescription: ']',
            defaultColor: primaryColor,
            ledColor: Colors.white)
      ],
      channelGroups: [NotificationChannelGroup(channelGroupKey: 'main_channel_group', channelGroupName: 'Main group')],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}