import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

import '../custom_sliver_persistent_header_delegate.dart';
import '../widgets/download_tracks_collection_header.dart';

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

  final GlobalKey _headerKey = GlobalKey();
  double? _headerHeight;
  double? _dynamicHeaderHeight;

  final double _appBarHeight = 55;
  final double _appBarStartShowingPercent = 0.5;
  Color _appBarColor = const Color.fromARGB(255, 101, 101, 101);
  double _appBarOpacity = 0;

  double get appBarHeightWithViewPadding => _appBarHeight + (MediaQuery.maybeOf(context)?.viewPadding.top ?? 0);

  @override
  void initState() {
    super.initState();
    _initTracksCollectionBloc();
    _getTracksCollectionBloc.add(GetTracksCollectionLoad());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _getAndDownloadTracksBloc.close();
    _getTracksCollectionBloc.close();
    _filterTracksBloc.close();

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
    final headerHiddenPercent = ((_dynamicHeaderHeight ?? 0) - appBarHeightWithViewPadding) /
        ((_headerHeight ?? 0) - appBarHeightWithViewPadding);
    final headerShowingPercent = 1 - headerHiddenPercent;

    final double newAppBarOpacity = ((headerShowingPercent - _appBarStartShowingPercent) / (1 - headerShowingPercent)).clamp(0, 1);

    if (newAppBarOpacity != _appBarOpacity) {
        _appBarOpacity = newAppBarOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  child: ScrollbarWithSlideAnimation(
                                      animationCurve: Curves.easeInOut,
                                      animationDuration: const Duration(milliseconds: 300),
                                      durationBeforeHide: const Duration(seconds: 2),
                                      thumbMargin: EdgeInsets.only(top: appBarHeightWithViewPadding + 10, bottom: 10),
                                      minScrollOffset:
                                          (_headerHeight ?? appBarHeightWithViewPadding) - appBarHeightWithViewPadding,
                                      hideThumbWhenOutOfOffset: true,
                                      thumbBuilder: (context, isDragging) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 7),
                                          child: Container(
                                              height: 50,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                  color: isDragging ? primaryColor : onBackgroundSecondaryColor,
                                                  borderRadius: BorderRadius.circular(2.5))),
                                        );
                                      },
                                      child: CustomScrollView(
                                        slivers: [
                                          SliverPersistentHeader(
                                              pinned: true,
                                              delegate: CustomSliverPersistentHeaderDelegate(
                                                maxHeight: _headerHeight ?? appBarHeightWithViewPadding,
                                                minHeight: appBarHeightWithViewPadding,
                                                onHeightCalculated: (height) {
                                                  if (_dynamicHeaderHeight != height) {
                                                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                                      setState(() {
                                                        _dynamicHeaderHeight = height;
                                                        _updateAppBarOpacity();
                                                      });
                                                    });
                                                  }
                                                },
                                                child: LayoutBuilder(builder: (context, constraints) {
                                                  if (_headerHeight == null) {
                                                    _planDynamicHeaderHeightUpdate();
                                                  }

                                                  return Stack(
                                                    children: [
                                                      Positioned(
                                                          bottom: 0,
                                                          width: constraints.maxWidth,
                                                          child: DownloadTracksCollectionHeader(
                                                              key: _headerKey,
                                                              backgroundGradientColor: _appBarColor,
                                                              title: getTracksCollectionState.tracksCollection.name,
                                                              imageUrl: getTracksCollectionState
                                                                      .tracksCollection.bigImageUrl ??
                                                                  '',
                                                              onFilterQueryChanged: _onFilterQueryChanged,
                                                              onAllDownloadButtonClicked: () =>
                                                                  _onAllDownloadButtonClicked(
                                                                      filterTracksState: _filterTracksBloc.state,
                                                                      getAndDownloadTracksState: getTracksState))),
                                                    ],
                                                  );
                                                }),
                                              )),
                                          BlocBuilder<FilterTracksBloc, FilterTracksState>(
                                            bloc: _filterTracksBloc,
                                            builder: (context, state) {
                                              if (state is! FilterTracksChanged) return const SliverToBoxAdapter();

                                              final filteredTracks = state.filteredTracks;
                                              final isTracksPlaceholdersDisplayed =
                                                  getTracksState is! GetAndDownloadTracksAllGot &&
                                                      state.isFilterQueryEmpty &&
                                                      getTracksCollectionState.tracksCollection.tracksCount != null;

                                              return SliverPrototypeExtentList.builder(
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
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
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
                                              );
                                            },
                                          ),
                                        ],
                                      ))))
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

  void _planDynamicHeaderHeightUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        _headerHeight = (_headerKey.currentContext!.findRenderObject() as RenderBox).size.height;
      });
    });
  }

  void _onFilterQueryChanged(newQuery) => _filterTracksBloc.add(FilterTracksChangeFilterQuery(newQuery: newQuery));

  void _onAllDownloadButtonClicked(
      {required FilterTracksState filterTracksState, required GetAndDownloadTracksState getAndDownloadTracksState}) {
    if (filterTracksState is! FilterTracksChanged) {
      return;
    }

    if (!filterTracksState.isFilterQueryEmpty || getAndDownloadTracksState is GetAndDownloadTracksAllGot) {
      _getAndDownloadTracksBloc
          .add(GetAndDownloadTracksDownloadTracksRange(tracksRange: filterTracksState.filteredTracks));
    } else {
      _getAndDownloadTracksBloc.add(GetAndDownloadTracksDownloadAllTracks());
    }
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
