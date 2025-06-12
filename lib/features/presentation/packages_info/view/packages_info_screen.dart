import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';
import 'package:spotify_downloader/oss_licenses.dart';

@RoutePage()
class PackagesInfoScreen extends StatelessWidget {
  const PackagesInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            CustomAppBar(title: S.of(context).packagesLicenses),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: CustomScrollView(
                    slivers: [
                      SliverList.builder(
                          itemCount: dependencies.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dependencies[index].name, style: theme.textTheme.bodyLarge),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        dependencies[index].license?.replaceAll(RegExp("(?<!^)\n\$"), "") ?? "",
                                        style: theme.textTheme.labelSmall?.copyWith(overflow: TextOverflow.visible),
                                      ),
                                    )
                                  ],
                                ));
                          }),
                      const SliverToBoxAdapter(
                        child: OrientatedNavigationBarListViewExpander(),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
