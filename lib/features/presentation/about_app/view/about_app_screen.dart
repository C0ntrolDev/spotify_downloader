import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/accessors/package_info/package_info_accessor.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';


@RoutePage()
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.6;
    final packageInfoAccessor = PackageInfoAccessor.maybeOf(context);

    return Scaffold(
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            CustomAppBar(title: S.of(context).aboutApp),
            Expanded(
              child: Padding(
                  padding: screenWithCustomAppBarPadding,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                  child: TapAnimatedContainer(
                                tappingMaskColor: backgroundColor.withOpacity(0.3),
                                tappingScale: 0.95,
                                onTap: () => _onAvatarClicked(context),
                                child: Container(
                                    height: avatarSize,
                                    width: avatarSize,
                                    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 7,
                                        blurRadius: 13,
                                      )
                                    ]),
                                    child: ClipOval(
                                        child: Image.asset(
                                      "resources/images/another/bestIcon3.png",
                                      fit: BoxFit.cover,
                                    ))),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 15),
                              child: Center(
                                child: Text(S.of(context).developedByC0ntrolDev,
                                    style: theme.textTheme.titleMedium, maxLines: 2, textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: Text(S.of(context).specialThanks, style: theme.textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipOval(
                                      child: SizedBox.fromSize(
                                          size: const Size.fromRadius(13),
                                          child:
                                              Image.asset("resources/images/another/thanks.png", fit: BoxFit.cover))),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("wimo"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: Text(S.of(context).appInfo, style: theme.textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(S.of(context).appName(packageInfoAccessor?.packageInfo.appName ?? "")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child:
                                  Text(S.of(context).packageName(packageInfoAccessor?.packageInfo.packageName ?? "")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(S.of(context).appVersion(packageInfoAccessor?.packageInfo.version ?? "")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child:
                                  Text(S.of(context).buildNumber(packageInfoAccessor?.packageInfo.buildNumber ?? "")),
                            ),
                          ],
                        ),
                      ),
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("^_^"),
                            ),
                            OrientatedNavigationBarListViewExpander(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAvatarClicked(BuildContext context) async {
    final githubUrl = Uri.parse("https://github.com/C0ntrolDev");
    await launchUrl(githubUrl);
  }
}
