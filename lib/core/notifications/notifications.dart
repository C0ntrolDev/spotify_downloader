import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

const String mainChannelKey = 'main_channel';

Future<void> initAwesomeNotifications() async {
  await AwesomeNotifications().initialize(
      'resource://drawable/notifications_icon',
      [
        NotificationChannel(
            channelGroupKey: 'main_channel_group',
            channelKey: 'main_channel',
            channelName: 'Main notifications',
            channelDescription: ']',
            defaultColor: primaryColor)
      ],
      channelGroups: [NotificationChannelGroup(channelGroupKey: 'main_channel_group', channelGroupName: 'Main group')],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}
