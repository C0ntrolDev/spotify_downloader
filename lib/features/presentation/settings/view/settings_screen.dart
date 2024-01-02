import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/features/presentation/home/view/home_screen.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/auth_settings/view/auth_settings.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/download_tracks_settings/view/download_tracks_settings_editor.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 55 + MediaQuery.of(context).viewPadding.top,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
            ),
            child: Row(
              children: [
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      AutoRouter.of(context).pop();
                    },
                    icon: SvgPicture.asset(
                      'resources/images/svg/back_icon.svg',
                      height: 35,
                      width: 35,
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Настройки',
                      style: theme.textTheme.titleSmall,
                    )),
              ],
            ),
          ),
        ),
        const Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: homePageHorizontalPadding, right: homePageHorizontalPadding, top: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AuthSettings(),
              DownloadTracksSettingsEditor()
            ]),
          ),
        ))
      ]),
    );
  }
}
