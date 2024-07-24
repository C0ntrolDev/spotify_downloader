import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/liked_tracks_tile.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/view/loading_tracks_collections_list.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchTextFieldController = TextEditingController();

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          left: false,
          right: false,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  CustomMainAppBar(
                    title: 'SpotifyDownloader',
                    icon: IconButton(
                        onPressed: () {
                          AutoRouter.of(context).push(const SettingsRoute());
                        },
                        icon: SvgPicture.asset(
                          'resources/images/svg/settings_icon.svg',
                          height: 27,
                          width: 27,
                        )),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 20),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).downloadFromLink, style: theme.textTheme.titleMedium),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SearchTextField(
                                    theme: theme,
                                    height: 45,
                                    iconPadding: const EdgeInsets.all(10),
                                    hintText: S.of(context).downloadFromLinkTextFieldHintText,
                                    controller: searchTextFieldController,
                                    onSubmitted: (value) async {
                                      if (isSearchRequestValid(value)) {
                                        await AutoRouter.of(context)
                                            .push(DownloadTracksCollectionRouteWithUrl(url: value));
                                        searchTextFieldController.clear();
                                      } else if (value != '') {
                                        searchTextFieldController.clear();
                                        showBigTextSnackBar(S.of(context).incorrectLink, context);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 40),
                          sliver: SliverToBoxAdapter(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).downloadLikedTracks, style: theme.textTheme.titleMedium),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: LikedTracksTile(
                                      theme: theme,
                                      title: S.of(context).likedTracksTitle,
                                      onTap: () {
                                        AutoRouter.of(context).push(
                                            DownloadTracksCollectionRouteWithHistoryTracksCollection(
                                                historyTracksCollection: HistoryTracksCollection.likedTracks));
                                      },
                                      image: const CachedNetworkImageProvider(
                                        'https://misc.scdn.co/liked-songs/liked-songs-300.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 40, bottom: 40),
                          sliver: MultiSliver(
                            children: [
                              SliverToBoxAdapter(
                                child: Text(S.of(context).activeDownloads, style: theme.textTheme.titleMedium),
                              ),
                              const SliverPadding(
                                  padding: EdgeInsets.only(top: 10), sliver: LoadingTracksCollectionsList())
                            ],
                          ),
                        ),
                        const SliverToBoxAdapter(child: CustomBottomNavigationBarListViewExpander())
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  bool isSearchRequestValid(String request) {
    return request.contains('https://open.spotify.com');
  }
}
