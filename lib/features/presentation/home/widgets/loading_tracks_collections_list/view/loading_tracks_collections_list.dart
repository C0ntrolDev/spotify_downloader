import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/bloc/loading_tracks_collections_list_bloc.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/view/loading_tracks_collection_tile.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class LoadingTracksCollectionsList extends StatefulWidget {
  const LoadingTracksCollectionsList({super.key});

  @override
  State<LoadingTracksCollectionsList> createState() => _LoadingTracksCollectionsListState();
}

class _LoadingTracksCollectionsListState extends State<LoadingTracksCollectionsList> {
  final LoadingTracksCollectionsListBloc _bloc = injector.get<LoadingTracksCollectionsListBloc>();

  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final List<LoadingTracksCollectionObserver> currentList = List.empty(growable: true);

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
          if (state is LoadingTracksCollectionsListLoaded) {
            _updateCurrentList(state.loadingCollectionsObservers);
          }
          setState(() {});
        },
        child: Stack(
          children: [
            AnimatedList(
                key: animatedListKey,
                padding: const EdgeInsets.all(0),
                initialItemCount: currentList.length,
                itemBuilder: (context, index, animate) => _buildAnimatedTile(context, currentList[index], animate)),
            LayoutBuilder(builder: (context, constrains) {
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
                    S.of(context).errorOccurredWhileLoadingActiveDownloads(
                        blocState.failure?.message.toString() ?? 'the message isn\'t specified'),
                    style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor));
              }

              if (blocState is LoadingTracksCollectionsListLoaded) {
                if (currentList.isEmpty) {
                  return Center(
                    child: Text(S.of(context).tracksDontLoad,
                        style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor)),
                  );
                }
              }

              return Container();
            }),
          ],
        ));
  }

  void _updateCurrentList(List<LoadingTracksCollectionObserver> newList) {
    final itemsToAdd = newList
        .where((newObserver) => currentList.where((oldObserver) => oldObserver == newObserver).isEmpty)
        .toList();
    final itemsToRemove = currentList
        .where((oldObserver) => newList.where((newObserver) => oldObserver == newObserver).isEmpty)
        .toList();

    for (var removedItem in itemsToRemove) {
      animatedListKey.currentState!.removeItem(currentList.indexOf(removedItem),
          (context, animation) => _buildAnimatedTile(context, removedItem, animation));
      currentList.remove(removedItem);
    }

    for (var newItem in itemsToAdd) {
      currentList.add(newItem);
      animatedListKey.currentState!.insertItem(currentList.length - 1);
    }
  }

  Widget _buildAnimatedTile(BuildContext context, LoadingTracksCollectionObserver loadingTracksCollectionObserver,
      Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
          opacity: animation,
          child: LoadingTracksCollectionTile(
            loadingTracksCollection: loadingTracksCollectionObserver,
            key: ObjectKey(loadingTracksCollectionObserver),
          )),
    );
  }
}
