import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/blocs.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/widgets.dart';

import 'package:spotify_downloader/generated/l10n.dart';
import 'dart:math' as math;

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

  final ScrollController _outerScrollController = ScrollController();

  final GlobalKey _headerInsideKey = GlobalKey();
  final GlobalKey<NestedScrollViewState> _neastedScrollViewKey = GlobalKey();

  double? _dynamicHeaderHeight;

  final double _appBarHeight = 55;
  final double _appBarStartShowingPercent = 0.3;
  Color _appBarColor = const Color.fromARGB(255, 101, 101, 101);
  double _appBarOpacity = 0;

  @override
  void initState() {
    super.initState();
    _initTracksCollectionBloc();
    _getTracksCollectionBloc.add(GetTracksCollectionLoad());

    _outerScrollController.addListener(_updateAppBarOpacity);
  }

  @override
  void dispose() {
    _getAndDownloadTracksBloc.close();
    _getTracksCollectionBloc.close();
    _filterTracksBloc.close();

    _outerScrollController.dispose();

    super.dispose();
  }

  void _initTracksCollectionBloc() {
    if (widget.historyTracksCollection != null) {
      _getTracksCollectionBloc =
          injector.get<GetTracksCollectionByHistoryBloc>(param1: widget.historyTracksCollection);
    } else if (widget.url != null) {
      _getTracksCollectionBloc = injector.get<GetTracksCollectionByUrlBloc>(param1: widget.url);
    }
  }

  void _updateAppBarOpacity() {
    final headerHiddenPercent = _outerScrollController.offset / (_outerScrollController.position.maxScrollExtent);

    var newAppBarOpacity =
      clampDouble((headerHiddenPercent - _appBarStartShowingPercent) / (1 - _appBarStartShowingPercent), 0, 1);

    if (newAppBarOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newAppBarOpacity;
      });
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
                            }, child: LayoutBuilder(builder: (context, neastedScrollViewConstraints) {
                              return NestedScrollView(
                                key: _neastedScrollViewKey,
                                controller: _outerScrollController,
                                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                                  return [
                                    SliverOverlapAbsorber(
                                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                                      sliver: SliverPersistentHeader(
                                          pinned: true,
                                          delegate: CustomSliverPersistentHeaderDelegate(
                                            maxHeight: _dynamicHeaderHeight ??
                                                _appBarHeight + MediaQuery.of(context).viewPadding.top,
                                            minHeight: _appBarHeight + MediaQuery.of(context).viewPadding.top,
                                            child: LayoutBuilder(builder: (context, constraints) {
                                              WidgetsBinding.instance.addPostFrameCallback((duration) {
                                                _dynamicHeaderHeight =
                                                    (_headerInsideKey.currentContext!.findRenderObject() as RenderBox)
                                                        .size
                                                        .height;

                                                setState(() {});
                                              });
                                              return Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    width: constraints.maxWidth,
                                                    child: AnimatedContainer(
                                                        key: _headerInsideKey,
                                                        duration: const Duration(milliseconds: 700),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(colors: [
                                                          _appBarColor,
                                                          backgroundColor,
                                                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(context).viewPadding.top + 20,
                                                            bottom: 20),
                                                        child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                                            child: Column(children: [
                                                              Builder(builder: (context) {
                                                                return Center(
                                                                    child: CachedNetworkImage(
                                                                  width: MediaQuery.of(context).size.width * 0.6,
                                                                  height: MediaQuery.of(context).size.width * 0.6,
                                                                  fit: BoxFit.contain,
                                                                  imageUrl: getTracksCollectionState
                                                                          .tracksCollection.bigImageUrl ??
                                                                      '',
                                                                  placeholder: (context, imageUrl) => Image.asset(
                                                                      'resources/images/another/loading_track_collection_image.png'),
                                                                  errorWidget: (context, imageUrl, _) => Image.asset(
                                                                      'resources/images/another/loading_track_collection_image.png'),
                                                                ));
                                                              }),
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    top: 10, left: 30, right: 30),
                                                                child: Text(
                                                                  getTracksCollectionState.tracksCollection.name,
                                                                  style: theme.textTheme.titleLarge,
                                                                  maxLines: 2,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.only(top: 30),
                                                                  child: TracksCollectionManageBar(
                                                                      onFilterQueryChanged: (newQuery) =>
                                                                          _filterTracksBloc.add(
                                                                              FilterTracksChangeFilterQuery(
                                                                                  newQuery: newQuery)),
                                                                      onAllDownloadButtonClicked: () {
                                                                        final filterTracksBlocState =
                                                                            _filterTracksBloc.state;
                                                                        if (filterTracksBlocState
                                                                            is! FilterTracksChanged) {
                                                                          return;
                                                                        }

                                                                        if (!filterTracksBlocState
                                                                                .isFilterQueryEmpty ||
                                                                            getTracksState
                                                                                is GetAndDownloadTracksAllGot) {
                                                                          _getAndDownloadTracksBloc.add(
                                                                              GetAndDownloadTracksDownloadTracksRange(
                                                                                  tracksRange: filterTracksBlocState
                                                                                      .filteredTracks));
                                                                        } else {
                                                                          _getAndDownloadTracksBloc.add(
                                                                              GetAndDownloadTracksDownloadAllTracks());
                                                                        }
                                                                      })),
                                                            ]))),
                                                  ),
                                                ],
                                              );
                                            }),
                                          )),
                                    )
                                  ];
                                },
                                body: BlocBuilder<FilterTracksBloc, FilterTracksState>(
                                  bloc: _filterTracksBloc,
                                  builder: (context, state) {
                                    if (state is! FilterTracksChanged) return const SliverToBoxAdapter();

                                    final filteredTracks = state.filteredTracks;
                                    final isTracksPlaceholdersDisplayed =
                                        getTracksState is! GetAndDownloadTracksAllGot &&
                                            state.isFilterQueryEmpty &&
                                            getTracksCollectionState.tracksCollection.tracksCount != null;

                                    return Padding(
                                      padding:
                                          EdgeInsets.only(top: _appBarHeight + MediaQuery.of(context).viewPadding.top),
                                      child: ScrollbarWithSlideAnimation(
                                        animationCurve: Curves.easeInExpo,
                                        durationBeforeHide: const Duration(seconds: 2),
                                        thumbBuilder: (context, isDragging) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                            child: Container(
                                                height: 75,
                                                width: 3,
                                                decoration: BoxDecoration(
                                                    color: isDragging ? primaryColor : onBackgroundSecondaryColor,
                                                    borderRadius: BorderRadius.circular(1.5))),
                                          );
                                        },
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount: isTracksPlaceholdersDisplayed
                                              ? getTracksCollectionState.tracksCollection.tracksCount
                                              : filteredTracks.length,
                                          prototypeItem: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                                              child: TrackTilePlaceholder()),
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
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
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            })),
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
                        height: _appBarHeight,
                        firstColor: _appBarColor,
                        secondaryColor: backgroundColor,
                        title: getTracksCollectionState.tracksCollection.name,
                        opacity: _appBarOpacity,
                      );
                    }

                    return GradientAppBarWithOpacity.invisible(height: _appBarHeight);
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
      showBigTextSnackBar(S.of(context).nothingWasFoundAtThisUrl, context, const Duration(seconds: 3));
    } else if (failure is NotAuthorizedFailure) {
      showBigTextSnackBar(S.of(context).toAccessYouNeedToLogIn, context, const Duration(seconds: 3));
    } else {
      showSmallTextSnackBar(failure.toString(), context, const Duration(seconds: 3));
    }

    AutoRouter.of(context).pop();
  }
}

class CustomSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final Widget child;

  CustomSliverPersistentHeaderDelegate({required this.maxHeight, required this.minHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
