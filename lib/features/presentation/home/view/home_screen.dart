import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/liked_tracks_tile.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/view/loading_tracks_collections_list.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/search_text_field.dart';
import 'package:spotify_downloader/generated/l10n.dart';

const homePageHorizontalPadding = 15.0;

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
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: homePageHorizontalPadding),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SpotifyDownloader', style: theme.textTheme.titleLarge),
                      IconButton(
                          onPressed: () {
                            AutoRouter.of(context).push(const SettingsRoute());
                          },
                          icon: SvgPicture.asset(
                            'resources/images/svg/settings_icon.svg',
                            height: 27,
                            width: 27,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
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
                              await AutoRouter.of(context).push(DownloadTracksCollectionRouteWithUrl(url: value));
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
                Padding(
                  padding: const EdgeInsets.only(top: 40),
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
                            onTapped: () {
                               AutoRouter.of(context).push(DownloadTracksCollectionRouteWithHistoryTracksCollection(
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: homePageHorizontalPadding),
                      child: Text(S.of(context).activeDownloads, style: theme.textTheme.titleMedium),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          alignment: Alignment.topCenter,
                          child: const LoadingTracksCollectionsList()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  bool isSearchRequestValid(String request) {
    return request.contains('https://open.spotify.com');
  }
}
