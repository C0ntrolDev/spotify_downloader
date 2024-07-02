import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollableScreenWithCustomAppBar(
        title: S.of(context).aboutApp,
        body: Column(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    S.of(context).developed,
                    style: theme.textTheme.bodyLarge,
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10),
                child: const Text('C0ntrolDev'),
              ),
            ],
          ),
          Container(
              padding: const EdgeInsets.only(top: 20),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).specialThanks,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'w1mo',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Hexer10 - youtube_explode_dart', style: theme.textTheme.bodyMedium),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('rinukkusu - spotify-dart', style: theme.textTheme.bodyMedium),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('arthenica - ffmpeg-kit', style: theme.textTheme.bodyMedium),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Flutter community', style: theme.textTheme.bodyMedium),
                  ),
                ],
              )),
              const CustomBottomNavigationBarListViewExpander()
        ]));
  }
}
