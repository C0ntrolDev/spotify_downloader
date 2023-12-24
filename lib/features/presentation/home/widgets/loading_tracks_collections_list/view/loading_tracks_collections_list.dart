import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/bloc/loading_tracks_collections_list_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/view/loading_tracks_collection_tile.dart';

class LoadingTracksCollectionsList extends StatefulWidget {
  const LoadingTracksCollectionsList({super.key});

  @override
  State<LoadingTracksCollectionsList> createState() => _LoadingTracksCollectionsListState();
}

class _LoadingTracksCollectionsListState extends State<LoadingTracksCollectionsList> {
  final LoadingTracksCollectionsListBloc _bloc = injector.get<LoadingTracksCollectionsListBloc>();

  @override
  void initState() {
    _bloc.add(LoadingTracksCollectionsListLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoadingTracksCollectionsListBloc, LoadingTracksCollectionsListState>(
        bloc: _bloc,
        listener: (context, state) {
          setState(() {});
        },
        child: LayoutBuilder(builder: (context, constrains) {
          final blocState = _bloc.state;

          if (blocState is LoadingTracksCollectionsListInitial) {
            return Container(
              height: constrains.maxHeight - bottomNavigationBarHeight,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          if (blocState is LoadingTracksCollectionsListFailure) {
            return Text(
                'Ошибка загрузки активных треков: ${blocState.failure?.message.toString() ?? 'the message isn\'t specified'}',
                style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor));
          }

          if (blocState is LoadingTracksCollectionsListLoaded) {
            if (blocState.loadingCollectionsObservers.isEmpty) {
              return Center(
                child: Text('Ничего не загружается   ^_^',
                    style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor)),
              );
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: blocState.loadingCollectionsObservers.length,
                  itemBuilder: (context, index) {
                    return LoadingTracksCollectionTile(
                        loadingTracksCollection: blocState.loadingCollectionsObservers[index]);
                  });
            }
          }

          return Container();
        }));
  }
}
