import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/history/bloc/history_bloc.dart';

@RoutePage()
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutoRouteAwareStateMixin<HistoryScreen> {
  final HistoryBloc _historyBloc = injector.get<HistoryBloc>();

  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    _historyBloc.add(HistoryBlocLoadHistory());
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    _historyBloc.add(HistoryBlocLoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20, left: 15, right: 15),
        child: Column(children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('История поиска', style: theme.textTheme.titleLarge)],
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              bloc: _historyBloc,
              builder: (context, state) {
                if (state is HistoryBlocLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomScrollView(
                      slivers: [
                        SliverList.builder(
                            itemCount: state.historyTracksCollections.length,
                            itemBuilder: (context, index) {
                              final historyTracksCollection = state.historyTracksCollections[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  CachedNetworkImage(
                                    width: 70,
                                    height: 70,
                                    imageUrl: historyTracksCollection.imageUrl ?? '',
                                    placeholder: (context, imageUrl) =>
                                        Image.asset('resources/images/another/loading_track_collection_image.png'),
                                    errorWidget: (context, imageUrl, _) =>
                                        Image.asset('resources/images/another/loading_track_collection_image.png'),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        historyTracksCollection.name,
                                        style: theme.textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        iconSize: 30,
                                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                                        color: onBackgroundSecondaryColor,
                                        onPressed: () async {
                                          AutoRouter.of(context)
                                              .push(DownloadTracksCollectionRouteWithHistoryTracksCollection(
                                                  historyTracksCollection: historyTracksCollection))
                                              .then((value) => _historyBloc.add(HistoryBlocLoadHistory()));
                                        },
                                      ))
                                ]),
                              );
                            }),
                        SliverToBoxAdapter(
                          child: Container(height: bottomNavigationBarHeight),
                        )
                      ],
                    ),
                  );
                }

                if (state is HistoryBlocLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Container();
              },
            ),
          )
        ]),
      ),
    );
  }
}
