import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/home/bloc/home_bloc.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/search_text_field.dart';
import '../widgets/playlist_tile.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = injector.get<HomeBloc>();
  final TextEditingController searchTextFieldController = TextEditingController();

  _HomeScreenState() {
    _homeBloc.add(HomeLoad());
  }

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
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20, left: 15, right: 15),
        child: Column(children: [
          Row(
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Неправильная ссылка',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          duration: const Duration(seconds: 2),
                        ));
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
                    child: PlaylistTile(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('История загрузок', style: theme.textTheme.titleMedium),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: BlocBuilder<HomeBloc, HomeState>(
                            bloc: _homeBloc,
                            builder: (context, state) {
                              if (state is HomeLoaded) {
                                return NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (OverscrollIndicatorNotification overScroll) {
                                    overScroll.disallowIndicator();
                                    return false;
                                  },
                                  child: ListView.builder(
                                    itemCount: state.tracksCollectionsHistory?.length ?? 0,
                                    itemBuilder: (context, index) => Text(state.tracksCollectionsHistory![index].name),
                                  ),
                                );
                              }

                              return Container();
                            },
                          )),
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
