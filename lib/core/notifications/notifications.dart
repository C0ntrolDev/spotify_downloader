import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

const String mainChannelKey = 'main_channel';
const String mainChannelGroupKey = 'main_channel_group';

Future<void> initAwesomeNotifications() async {
  await AwesomeNotifications().initialize(
      'resource://drawable/notifications_icon',
      [
        NotificationChannel(
            channelGroupKey: mainChannelGroupKey,
            channelKey: mainChannelKey,
            channelName: 'Main Notifications',
            channelDescription: 'Main Notifications of Spotify Downloader',
            defaultColor: primaryColor)
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: mainChannelGroupKey, channelGroupName: 'Main Notifications Group')
      ],
      debug: true);
}
