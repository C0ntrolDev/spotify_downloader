import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/features/presentation/settings/widgets/widgets.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollableScreenWithCustomAppBar(
      title: S.of(context).settings,
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        const AuthSettings(),
        const DownloadTracksSettingsEditor(),
        SettingsGroup(header: S.of(context).other, settings: [
          const LanguageSetting(),
          SizedBox(
            height: 40,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                AutoRouter.of(context).push(const AboutAppRoute());
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(S.of(context).aboutApp),
                  ),
                  const Icon(
                    Icons.info_outline_rounded,
                    color: onBackgroundSecondaryColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: 40,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  AutoRouter.of(context).push(const PackagesInfoRoute());
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(S.of(context).packagesLicenses),
                    ),
                    const Icon(
                      Icons.favorite_outline_sharp,
                      color: onBackgroundSecondaryColor,
                      size: 30,
                    ),
                  ],
                ),
              ))
        ]),
        const OrientatedNavigationBarListViewExpander()
      ]),
    );
  }
}
