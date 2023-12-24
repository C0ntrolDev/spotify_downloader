import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/view/loading_tracks_collections_list.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/search_text_field.dart';
import '../widgets/liked_tracks_tile.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SpotifyDownloader', style: theme.textTheme.titleLarge),
                      IconButton(
                          onPressed: () {},
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
                      Text('Скачать по ссылке', style: theme.textTheme.titleMedium),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SearchTextField(
                          theme: theme,
                          height: 45,
                          iconPadding: const EdgeInsets.all(10),
                          hintText: 'Ссылка на трек, плейлист или альбом',
                          controller: searchTextFieldController,
                          onSubmitted: (value) async {
                            if (isSearchRequestValid(value)) {
                              await AutoRouter.of(context).push(DownloadTracksCollectionRouteWithUrl(url: value));
                              searchTextFieldController.clear();
                            } else if (value != '') {
                              searchTextFieldController.clear();
                              showBigTextSnackBar('Неправильная ссылка', context);
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
                        Text('Скачать любимые треки', style: theme.textTheme.titleMedium),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: LikedTracksTile(
                            theme: theme,
                            title: 'Любимые треки',
                            onTapped: () {},
                            image: const AssetImage(
                              'resources/images/another/liked_tracks.jpg',
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Активные загрузки', style: theme.textTheme.titleMedium),
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
