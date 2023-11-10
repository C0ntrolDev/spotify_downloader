import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      body: Column(children: [
        ElevatedButton(onPressed: () => addPlaylistIHistory(), child: Text('Добавить в историю')),
        Expanded(child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.playlistsHistory?.length ?? 0, 
                itemBuilder: (context, index) => new Row(children: [
                  Text(state.playlistsHistory![index].name),
                  Text(state.playlistsHistory![index].openDate.toIso8601String())
                ],),);
            }

            return Container(color: Color.fromARGB(255, 255, 0, 0),);
          },
        )
        )
      ]),
    );
  }

  void addPlaylistIHistory() {
    _homeBloc.add(HomeAddPlaylistToHistory(playlist: Playlist.withLocalImage(spotifyId: '2', name: 'H1is', openDate: DateTime.now(),  image: null)));
  }
}
