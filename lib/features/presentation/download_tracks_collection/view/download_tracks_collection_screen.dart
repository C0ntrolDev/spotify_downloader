import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/core/util/util_methods.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/filter_tracks/filter_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_and_download_tracks/get_and_download_tracks_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/base/get_tracks_collection_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_history_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/get_tracks_collection_by_url_bloc.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/gradient_app_bar_with_opacity.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/network_failure_splash.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile/view/track_tile.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/track_tile_placeholder.dart';
import 'dart:math' as math;

import '../widgets/tracks_collection_manage_bar.dart';

abstract class DownloadTracksCollectionScreen extends StatefulWidget {
  final String? url;
  final HistoryTracksCollection? historyTracksCollection;

  const DownloadTracksCollectionScreen.withUrl({super.key, required this.url}) : historyTracksCollection = null;
  const DownloadTracksCollectionScreen.withHistoryTracksCollection({super.key, required this.historyTracksCollection})
      : url = null;

  @override
  State<DownloadTracksCollectionScreen> createState() => _DownloadTracksCollectionScreenState();
}

@RoutePage()
class DownloadTracksCollectionScreenWithUrl extends DownloadTracksCollectionScreen {
  const DownloadTracksCollectionScreenWithUrl({super.key, required String url}) : super.withUrl(url: url);
}

@RoutePage()
class DownloadTracksCollectionScreenWithHistoryTracksCollection extends DownloadTracksCollectionScreen {
  const DownloadTracksCollectionScreenWithHistoryTracksCollection(
      {super.key, required HistoryTracksCollection historyTracksCollection})
      : super.withHistoryTracksCollection(historyTracksCollection: historyTracksCollection);
}

class _DownloadTracksCollectionScreenState extends State<DownloadTracksCollectionScreen>
    with SingleTickerProviderStateMixin {
  late final GetTracksCollectionBloc _getTracksCollectionBloc;
  final GetAndDownloadTracksBloc _getAndDownloadTracksBloc = injector.get<GetAndDownloadTracksBloc>();
  final FilterTracksBloc _filterTracksBloc = injector.get<FilterTracksBloc>();

  final ScrollController _screenScrollController = ScrollController();
  final double _tracksCollectionInfoHeight = 250;

  Color _appBarColor = const Color.fromARGB(255, 101, 101, 101);
  double _appBarOpacity = 0;

  @override
  void initState() {
    super.initState();
    initTracksCollectionBloc();
    _getTracksCollectionBloc.add(GetTracksCollectionLoad());
  }

  @override
  void dispose() {
    _getAndDownloadTracksBloc.close();
    _getTracksCollectionBloc.close();
    _filterTracksBloc.close();
    super.dispose();
  }

  void initTracksCollectionBloc() {
    if (widget.historyTracksCollection != null) {
      _getTracksCollectionBloc =
          injector.get<GetTracksCollectionByHistoryBloc>(param1: widget.historyTracksCollection);
    } else if (widget.url != null) {
      _getTracksCollectionBloc = injector.get<GetTracksCollectionByUrlBloc>(param1: widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<GetTracksCollectionBloc, GetTracksCollectionState>(
          bloc: _getTracksCollectionBloc,
          listener: (context, state) {
            if (state is GetTracksCollectionLoaded) {
              _generateAppBarColor(state.tracksCollection.bigImageUrl);
              _getAndDownloadTracksBloc.add(GetAndDownloadTracksGetTracks(tracksCollection: state.tracksCollection));
            }

            if (state is GetTracksCollectionFailure) {
              _onFatalFailure(state.failure);
              return;
            }
          },
        ),
        BlocListener<GetAndDownloadTracksBloc, GetAndDownloadTracksState>(
          bloc: _getAndDownloadTracksBloc,
          listener: (context, state) {
            if (state is GetAndDownloadTracksFailure) {
              _onFatalFailure(state.failure);
            }

            if (state is GetAndDownloadTracksTracksGot) {
              _filterTracksBloc.add(FilterTracksChangeSource(newSource: state.tracksWithLoadingObservers));
            }
          },
        )
      ],
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<GetTracksCollectionBloc, GetTracksCollectionState>(
              bloc: _getTracksCollectionBloc,
              builder: (context, getTracksCollectionState) {
                if (getTracksCollectionState is GetTracksCollectionNetworkFailure) {
                  return NetworkFailureSplash(
                      onRetryAgainButtonClicked: () => _getTracksCollectionBloc.add(GetTracksCollectionLoad()));
                }

                if (getTracksCollectionState is GetTracksCollectionLoaded) {
                  return BlocBuilder<GetAndDownloadTracksBloc, GetAndDownloadTracksState>(
                    bloc: _getAndDownloadTracksBloc,
                    builder: (context, getTracksState) {
                      if (getTracksState is GetAndDownloadTracksBeforePartGotNetworkFailure) {
                        return NetworkFailureSplash(
                            onRetryAgainButtonClicked: () => _getAndDownloadTracksBloc.add(
                                GetAndDownloadTracksGetTracks(
                                    tracksCollection: getTracksCollectionState.tracksCollection)));
                      }

                      if (getTracksState is GetAndDownloadTracksTracksGot) {
                        return Stack(children: [
                          Container(
                            alignment: AlignmentDirectional.topCenter,
                            child: NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (OverscrollIndicatorNotification overScroll) {
                                  overScroll.disallowIndicator();
                                  return false;
                                },
                                child: Scrollbar(
                                    controller: _screenScrollController,
                                    child: CustomScrollView(
                                        controller: _screenScrollController
                                          ..addListener(() {
                                            _appBarOpacity = math.min(
                                                1, _screenScrollController.offset / _tracksCollectionInfoHeight);
                                            setState(() {});
                                          }),
                                        slivers: [
                                          SliverToBoxAdapter(
                                              child: Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 30),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 700),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [
                                                  _appBarColor,
                                                  backgroundColor,
                                                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                                                padding:
                                                    EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Column(children: [
                                                    Center(
                                                        child: CachedNetworkImage(
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      height: MediaQuery.of(context).size.width * 0.6,
                                                      fit: BoxFit.fitWidth,
                                                      imageUrl:
                                                          getTracksCollectionState.tracksCollection.bigImageUrl ?? '',
                                                      placeholder: (context, imageUrl) => Image.asset(
                                                          'resources/images/another/loading_track_collection_image.png'),
                                                      errorWidget: (context, imageUrl, _) => Image.asset(
                                                          'resources/images/another/loading_track_collection_image.png'),
                                                    )),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15),
                                                      child: Text(
                                                        getTracksCollectionState.tracksCollection.name,
                                                        style: theme.textTheme.titleLarge,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.only(top: 30),
                                                        child: TracksCollectionManageBar(
                                                            onFilterQueryChanged: (newQuery) => _filterTracksBloc.add(
                                                                FilterTracksChangeFilterQuery(newQuery: newQuery)),
                                                            onAllDownloadButtonClicked: () {
                                                              final filterTracksBlocState = _filterTracksBloc.state;
                                                              if (filterTracksBlocState is! FilterTracksChanged) {
                                                                return;
                                                              }
                                                              
                                                              if (!filterTracksBlocState.isFilterQueryEmpty ||
                                                                  getTracksState is GetAndDownloadTracksAllGot) {
                                                                _getAndDownloadTracksBloc.add(
                                                                    GetAndDownloadTracksDownloadTracksRange(
                                                                        tracksRange:
                                                                            filterTracksBlocState.filteredTracks));
                                                              } else {
                                                                _getAndDownloadTracksBloc
                                                                    .add(GetAndDownloadTracksDownloadAllTracks());
                                                              }
                                                            })),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ])),
                                          BlocBuilder<FilterTracksBloc, FilterTracksState>(
                                            bloc: _filterTracksBloc,
                                            builder: (context, state) {
                                              if (state is! FilterTracksChanged) return const SliverToBoxAdapter();

                                              final filteredTracks = state.filteredTracks;
                                              final isTracksPlaceholdersDisplayed =
                                                  getTracksState is! GetAndDownloadTracksAllGot &&
                                                      state.isFilterQueryEmpty;

                                              return SliverList.builder(
                                                  itemCount: isTracksPlaceholdersDisplayed
                                                      ? getTracksCollectionState.tracksCollection.tracksCount
                                                      : filteredTracks.length,
                                                  itemBuilder: (context, index) {
                                                    return Stack(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 15, vertical: 7.5),
                                                          child: Builder(builder: (buildContext) {
                                                            if (index < (state.filteredTracks.length)) {
                                                              return TrackTile(
                                                                trackWithLoadingObserver: filteredTracks[index],
                                                                key: ObjectKey(filteredTracks[index]),
                                                              );
                                                            }

                                                            return const TrackTilePlaceholder();
                                                          }),
                                                        ),
                                                        Builder(
                                                          builder: (buildContext) {
                                                            if (getTracksState
                                                                is GetAndDownloadTracksAfterPartGotNetworkFailure) {
                                                              return Positioned.fill(
                                                                child: IgnorePointer(
                                                                  child: Container(
                                                                    color: const Color.fromARGB(50, 0, 0, 0),
                                                                    height: 10,
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            return Container();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ]))),
                          )
                        ]);
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            BlocBuilder<GetTracksCollectionBloc, GetTracksCollectionState>(
              bloc: _getTracksCollectionBloc,
              builder: (context, getTracksCollectionState) {
                return BlocBuilder<GetAndDownloadTracksBloc, GetAndDownloadTracksState>(
                  bloc: _getAndDownloadTracksBloc,
                  builder: (context, getTracksState) {
                    if (getTracksCollectionState is GetTracksCollectionLoaded &&
                        getTracksState is GetAndDownloadTracksTracksGot) {
                      return GradientAppBarWithOpacity.visible(
                        firstColor: _appBarColor,
                        secondaryColor: backgroundColor,
                        title: getTracksCollectionState.tracksCollection.name,
                        opacity: _appBarOpacity,
                      );
                    }

                    return const GradientAppBarWithOpacity.invisible();
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _generateAppBarColor(String? imageUrl) {
    if (imageUrl != null) {
      Future(() async {
        final generator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));

        final imageColor = generator.mutedColor?.color ?? generator.dominantColor?.color;
        if (imageColor != null) {
          _appBarColor = getIntermediateColor(imageColor, backgroundColor, 0.2);
        }
        try {
          setState(() {});
        } catch (e) {
          //if widget disposed
        }
      });
    } else {
      _appBarColor = backgroundColor;
    }
  }

  void _onFatalFailure(Failure? failure) {
    if (failure is NotFoundFailure) {
      showBigTextSnackBar('По данному url не было ничего найдено', context, const Duration(seconds: 3));
    } else {
      showSmallTextSnackBar(failure.toString(), context, const Duration(seconds: 3));

      AutoRouter.of(context).pop();
    }
  }
}
