import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/home/domain/entities/playlist.dart';
import 'package:spotify_downloader/features/home/presentation/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = injector.get<HomeBloc>();

  _HomeScreenState() {
    _homeBloc.add(HomeLoad());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [backgroundGradientColor, backgroundColor],
                begin: Alignment(0, -1.0),
                end: Alignment(0, -0.6))),
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
            padding: EdgeInsets.only(top: 30),
            child: Container(
              decoration: BoxDecoration(color: searchFieldColor, borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  SizedBox(
                    child: TextField(
                      style: theme.textTheme.bodyMedium?.copyWith(color: onPrimaryColor),
                      decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SvgPicture.asset(
                              'resources/images/svg/search_icon.svg',
                              height: 27,
                              width: 27,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Ссылка на трек, плейлист или альбом',
                          hintMaxLines: 1,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: onSearchFieldColor)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  void addPlaylistIHistory() {
    _homeBloc.add(HomeAddPlaylistToHistory(
        playlist: Playlist.withLocalImage(spotifyId: '2', name: 'H1is', openDate: DateTime.now(), image: null)));
  }
}
