import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/presentation/history/bloc/history_bloc.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutoRouteAwareStateMixin<HistoryScreen> {
  final HistoryBloc _historyBloc = injector.get<HistoryBloc>();

  @override
  void initState() {
    super.initState();
    _historyBloc.add(HistoryBlocLoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            CustomMainAppBar(
              title: S.of(context).searchHistory,
              contentPadding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            ),
            Expanded(
              child: CustomScrollView(slivers: [
                BlocBuilder<HistoryBloc, HistoryState>(
                  bloc: _historyBloc,
                  builder: (context, state) {
                    if (state is HistoryBlocLoaded) {
                      return SliverList.builder(
                          itemCount: state.historyTracksCollections.length,
                          itemBuilder: (context, index) {
                            final historyTracksCollection = state.historyTracksCollections[index];
                            return TapAnimatedContainer(
                              tappingMaskColor: backgroundColor.withOpacity(0.4),
                              tappingScale: 0.99,
                              onTap: () async {
                                AutoRouter.of(context)
                                    .push(DownloadTracksCollectionRouteWithHistoryTracksCollection(
                                        historyTracksCollection: historyTracksCollection))
                                    .then((value) => _historyBloc.add(HistoryBlocLoadHistory()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: horizontalPadding),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  CachedNetworkImage(
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fitWidth,
                                    memCacheWidth: (70 * MediaQuery.of(context).devicePixelRatio).round(),
                                    imageUrl: historyTracksCollection.imageUrl ?? '',
                                    placeholder: (context, imageUrl) =>
                                        Image.asset('resources/images/another/loading_track_collection_image.png'),
                                    errorWidget: (context, imageUrl, _) =>
                                        Image.asset('resources/images/another/loading_track_collection_image.png'),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        historyTracksCollection.name,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(Icons.arrow_forward_ios_rounded,
                                        color: onBackgroundSecondaryColor, size: 27),
                                  )
                                ]),
                              ),
                            );
                          });
                    }

                    if (state is HistoryBlocLoading) {
                      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                    }

                    return Container();
                  },
                ),
                const SliverToBoxAdapter(
                  child: CustomBottomNavigationBarListViewExpander(),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
