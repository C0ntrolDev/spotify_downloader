import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/observe_tracks_loading/domain/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/cubit/loading_tracks_collections_list_cubit.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/view/loading_tracks_collection_tile.dart';
import 'package:spotify_downloader/generated/l10n.dart';

class LoadingTracksCollectionsList extends StatefulWidget {
  const LoadingTracksCollectionsList({super.key});

  @override
  State<LoadingTracksCollectionsList> createState() => _LoadingTracksCollectionsListState();
}

class _LoadingTracksCollectionsListState extends State<LoadingTracksCollectionsList> {
  final LoadingTracksCollectionsListCubit _cubit = injector.get<LoadingTracksCollectionsListCubit>();

  final GlobalKey<SliverAnimatedListState> animatedListKey = GlobalKey();
  final List<LoadingTracksCollectionObserver> currentList = List.empty(growable: true);

  @override
  void initState() {
    _cubit.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoadingTracksCollectionsListCubit, LoadingTracksCollectionsListState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is LoadingTracksCollectionsListLoaded) {
          _updateCurrentList(state.loadingCollectionsObservers);
        }
      },
      child: SliverStack(children: [
        SliverAnimatedList(
            key: animatedListKey,
            initialItemCount: currentList.length,
            itemBuilder: (context, index, animate) => _buildAnimatedTile(context, currentList[index], animate)),
        SliverToBoxAdapter(child: BlocBuilder<LoadingTracksCollectionsListCubit, LoadingTracksCollectionsListState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is LoadingTracksCollectionsListLoaded && currentList.isEmpty) {
              return Text(S.of(context).tracksDontLoad,
                  style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor));
            }

            if (state is LoadingTracksCollectionsListInitial) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (state is LoadingTracksCollectionsListFailure) {
              return Text(
                  S.of(context).errorOccurredWhileLoadingActiveDownloads(
                      state.failure?.message.toString() ?? 'the message isn\'t specified'),
                  style: theme.textTheme.labelLarge?.copyWith(color: onBackgroundSecondaryColor));
            }

            return Container();
          },
        ))
      ]),
    );
  }

  void _updateCurrentList(List<LoadingTracksCollectionObserver> newList) {
    final itemsToAdd = newList
        .where((newObserver) => currentList.where((oldObserver) => oldObserver == newObserver).isEmpty)
        .toList();
    final itemsToRemove = currentList
        .where((oldObserver) => newList.where((newObserver) => oldObserver == newObserver).isEmpty)
        .toList();

    for (var removedItem in itemsToRemove) {
      final index = currentList.indexOf(removedItem);
      currentList.removeAt(index);
      animatedListKey.currentState?.removeItem(index,
          (context, animation) => _buildAnimatedTile(context, removedItem, animation));
    }

    for (var newItem in itemsToAdd) {
      currentList.add(newItem);
      animatedListKey.currentState?.insertItem(currentList.length - 1);
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