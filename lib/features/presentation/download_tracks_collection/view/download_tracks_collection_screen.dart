import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/blocs.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/download_track_info/view/download_track_info.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/tracks_type_depend_widgets/tracks_collection_type_depend_scrollbar.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/widgets/widgets.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar_acessor.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';

import 'package:spotify_downloader/generated/l10n.dart';

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
  final GetTracksBloc _getTracksBloc = injector.get<GetTracksBloc>();
  final FilterTracksBloc _filterTracksBloc = injector.get<FilterTracksBloc>();
  final DownloadTracksCubit _downloadTracksCubit = injector.get<DownloadTracksCubit>();

  final GlobalKey _headerKey = GlobalKey();
  double? _headerHeight;

  final ScrollController _scrollController = ScrollController();

  static const _defaultBackgroundGradientColor = Color.fromARGB(255, 101, 101, 101);
  Color _backgroundGradientColor = _defaultBackgroundGradientColor;

  final double _appBarStartShowingPercent = 0.6;
  final double _appBarEndShowingPercent = 0.9;

  double _appBarOpacityField = 0;
  double get _appBarOpacity => _appBarOpacityField;
  set _appBarOpacity(double newValue) {
    _appBarOpacityField = newValue;
    _appBarOpacityController.add(newValue);
  }

  final StreamController<double> _appBarOpacityController = StreamController.broadcast();

  double get appBarHeightWithViewPadding => appBarHeight + (MediaQuery.maybeOf(context)?.viewPadding.top ?? 0);

  @override
  void initState() {
    super.initState();
    _initTracksCollectionBloc();
    _getTracksCollectionBloc.add(GetTracksCollectionLoad());

    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _getTracksCollectionBloc.close();
    _filterTracksBloc.close();

    _scrollController.removeListener(_onScroll);

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

  void _onScroll() {
    if (_scrollController.offset <= (_headerHeight ?? 0) || _appBarOpacity != 0) {
      _updateAppBarOpacity(_scrollController.offset);
    }
  }

  void _updateAppBarOpacity(double hiddenPartOfHeader) {
    if (_headerHeight == null) return;

    final double hiddenPercent = (hiddenPartOfHeader / (_headerHeight! - appBarHeightWithViewPadding)).clamp(0, 1);
    double newAppBarOpacity =
        normalize(hiddenPercent, _appBarStartShowingPercent, _appBarEndShowingPercent).clamp(0, 1);

    if (newAppBarOpacity != _appBarOpacity) {
      _appBarOpacity = newAppBarOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTracksCollectionBloc>(
          create: (context) => _getTracksCollectionBloc,
        ),
        BlocProvider<GetTracksBloc>(
          create: (BuildContext context) => _getTracksBloc,
        ),
        BlocProvider<FilterTracksBloc>(
          create: (BuildContext context) => _filterTracksBloc,
        ),
        BlocProvider<DownloadTracksCubit>(
          create: (BuildContext context) => _downloadTracksCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetTracksCollectionBloc, GetTracksCollectionState>(
            listener: (context, state) async {
              if (state is GetTracksCollectionLoaded) {
                _generateBackgroundGradientColor(state.tracksCollection.bigImageUrl);
                _getTracksBloc.add(GetTracksGetTracks(tracksCollection: state.tracksCollection));
              }

              if (state is GetTracksCollectionFatalFailure) {
                _onFatalFailure(state.failure);
                return;
              }
            },
          ),
          BlocListener<GetTracksBloc, GetTracksState>(
            listener: (context, state) {
              if (state is GetTracksFatalFailure) {
                _onFatalFailure(state.failure);
                return;
              }

              if (state is GetTracksTracksGot) {
                _filterTracksBloc.add(FilterTracksChangeSource(newSource: state.tracksWithLoadingObservers));
              }

              _updateDownloadTracksCubit(state);
            },
          ),
          BlocListener<DownloadTracksCubit, DownloadTracksState>(listener: (context, state) {
            if (state is DownloadTracksFailure) {
              showSmallTextSnackBar(state.failure.toString(), context);
            }
          })
        ],
        child: Scaffold(
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Stack(
              children: [
                Builder(
                  builder: (context) {
                    final getTracksCollectionState = context.watch<GetTracksCollectionBloc>().state;
                    final getTracksState = context.watch<GetTracksBloc>().state;
                    final filteredTracksState = context.watch<FilterTracksBloc>().state;
                    
                    context.watch<DownloadTracksCubit>().state;

                    if (getTracksCollectionState is GetTracksCollectionNetworkFailure) {
                      return NetworkFailureSplash(
                          onRetryAgainButtonClicked: () => _getTracksCollectionBloc.add(GetTracksCollectionLoad()));
                    }

                    if (getTracksCollectionState is! GetTracksCollectionLoaded) {
                      return const Center(
                          child: SizedBox(height: 41, width: 41, child: StrangeOptimizedCircularProgressIndicator()));
                    }

                    if (getTracksState is GetTracksBeforePartGotNetworkFailure) {
                      return NetworkFailureSplash(
                          onRetryAgainButtonClicked: () => _getTracksBloc
                              .add(GetTracksGetTracks(tracksCollection: getTracksCollectionState.tracksCollection)));
                    }

                    if (getTracksState is! GetTracksTracksGot) {
                      return const Center(
                          child: SizedBox(height: 41, width: 41, child: StrangeOptimizedCircularProgressIndicator()));
                    }

                    _scheduleHeaderHeightUpdate();

                    final filteredTracks = filteredTracksState.filteredTracks;
                    final isTracksPlaceholdersDisplayed = getTracksState is! GetTracksAllGot &&
                        filteredTracksState.isFilterQueryEmpty &&
                        getTracksCollectionState.tracksCollection.tracksCount != null;

                    return NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return false;
                        },
                        child: TracksCollectionTypeDependScrollbar(
                            controller: _scrollController,
                            type: getTracksCollectionState.tracksCollection.type,
                            getTrackWithLoadingObserverByIndex: (index) {
                              if (index < 0 || index >= filteredTracks.length) {
                                return null;
                              }

                              return filteredTracks[index];
                            },
                            prototypeItem: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 7.5),
                                child: TrackTilePlaceholder()),
                            scrollbarPadding: EdgeInsets.only(
                                top: appBarHeightWithViewPadding + 10,
                                bottom: 10 + (OrientatedNavigationBarAcessor.maybeOf(context)?.expandedHeight ?? 0)),
                            minScrollOffset:
                                (_headerHeight ?? appBarHeightWithViewPadding) - appBarHeightWithViewPadding,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                DownloadTracksCollectionHeader(
                                  key: _headerKey,
                                  backgroundGradientColor: _backgroundGradientColor,
                                  imageUrl: getTracksCollectionState.tracksCollection.bigImageUrl ?? '',
                                  title: getTracksCollectionState.tracksCollection.name,
                                  onFilterQueryChanged: _onFilterQueryChanged,
                                  onDownloadAllButtonClicked: () => _onDownloadAllButtonClicked(
                                      filterTracksState: _filterTracksBloc.state, getTracksState: getTracksState),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.only(top: 20),
                                  sliver: SliverPrototypeExtentList.builder(
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
                                              if (index >= filteredTracks.length) {
                                                return const TrackTilePlaceholder();
                                              }

                                              final trackWithLoadingObserver = filteredTracks[index];

                                              return TracksCollectionTypeDependTrackTile(
                                                type: getTracksCollectionState.tracksCollection.type,
                                                trackWithLoadingObserver: trackWithLoadingObserver,
                                                isLoadedIfLoadingObserverIsNull:
                                                    _getIsTrackLoadedIfLoadingObserverIsNull(trackWithLoadingObserver),
                                                onDownloadButtonClicked: () =>
                                                    _downloadTracksCubit.downloadTrack(trackWithLoadingObserver),
                                                onCancelButtonClicked: () =>
                                                    _downloadTracksCubit.cancelTrackLoading(trackWithLoadingObserver),
                                                onMoreInfoClicked: () =>
                                                    _onMoreInfoButtonClicked(context, trackWithLoadingObserver),
                                              );
                                            }),
                                          ),
                                          if (getTracksState is GetTracksAfterPartGotNetworkFailure)
                                            Positioned.fill(
                                              child: IgnorePointer(
                                                child: Container(
                                                  color: const Color.fromARGB(50, 0, 0, 0),
                                                  height: 10,
                                                ),
                                              ),
                                            )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SliverToBoxAdapter(child: OrientatedNavigationBarListViewExpander())
                              ],
                            )));
                  },
                ),
                Builder(
                  builder: (context) {
                    final getTracksCollectionState = context.watch<GetTracksCollectionBloc>().state;
                    final getTracksState = context.watch<GetTracksBloc>().state;

                    if (getTracksCollectionState is! GetTracksCollectionLoaded ||
                        getTracksState is! GetTracksTracksGot) {
                      return const GradientAppBarWithOpacity.invisible();
                    }

                    return StreamBuilder<double>(
                        initialData: 0,
                        stream: _appBarOpacityController.stream,
                        builder: (context, newOpacity) {
                          return GradientAppBarWithOpacity.visible(
                            firstColor: _backgroundGradientColor,
                            secondaryColor: backgroundColor,
                            title: getTracksCollectionState.tracksCollection.name,
                            opacity: newOpacity.data ?? 0,
                          );
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onMoreInfoButtonClicked(BuildContext context, TrackWithLoadingObserver trackWithLoadingObserver) {
    return showDownloadTrackInfoBottomSheet(
        getCurrentYoutubeUrl: () => _getCurrentUrlOfTrack(trackWithLoadingObserver),
        getIsTrackLoadedIfLoadingObserverIsNull: () =>
            _getIsTrackLoadedIfLoadingObserverIsNull(trackWithLoadingObserver),
        context: context,
        trackWithLoadingObserver: trackWithLoadingObserver,
        onChangeYoutubeUrlClicked: () =>
            _onChangeYoutubeUrlClicked(trackWithLoadingObserver, _getCurrentUrlOfTrack(trackWithLoadingObserver)));
  }

  String? _getCurrentUrlOfTrack(TrackWithLoadingObserver trackWithLoadingObserver) {
    final preselectedYoutubeUrl = _downloadTracksCubit.state.preselectedTracksYouTubeUrls[trackWithLoadingObserver];
    return preselectedYoutubeUrl ??
        trackWithLoadingObserver.loadingObserver?.youtubeUrl ??
        trackWithLoadingObserver.track.localYoutubeUrl;
  }

  bool _getIsTrackLoadedIfLoadingObserverIsNull(TrackWithLoadingObserver trackWithLoadingObserver) {
    final preselectedYoutubeUrl = _downloadTracksCubit.state.preselectedTracksYouTubeUrls[trackWithLoadingObserver];
    return preselectedYoutubeUrl != null ? false : trackWithLoadingObserver.track.isLoaded;
  }

  void _scheduleHeaderHeightUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var newHeaderHeight = (_headerKey.currentContext!.findRenderObject() as RenderSliver).geometry?.scrollExtent;
      if (_headerHeight != newHeaderHeight) {
        setState(() {
          _headerHeight = newHeaderHeight;
        });
      }
    });
  }

  void _onFilterQueryChanged(String newQuery) =>
      _filterTracksBloc.add(FilterTracksChangeFilterQuery(newQuery: newQuery));

  void _onDownloadAllButtonClicked(
      {required FilterTracksDefault filterTracksState, required GetTracksState getTracksState}) {
    if (!filterTracksState.isFilterQueryEmpty) {
      _downloadTracksCubit.downloadTracksRange(filterTracksState.filteredTracks);
    } else {
      _downloadTracksCubit.downloadAllTracks();
    }
  }

  Future<bool> _onChangeYoutubeUrlClicked(
      TrackWithLoadingObserver trackWithLoadingObserver, String? oldYoutubeUrl) async {
    final changedUrl = await AutoRouter.of(context)
        .push<String?>(ChangeSourceVideoRoute(track: trackWithLoadingObserver.track, oldYoutubeUrl: oldYoutubeUrl));
    if (changedUrl != null) {
      _downloadTracksCubit.changeTrackYoutubeUrl(trackWithLoadingObserver, changedUrl);
      return true;
    }

    return false;
  }

  Future<void> _generateBackgroundGradientColor(String? imageUrl) async {
    Color newBackgroundGradientColor;
    if (imageUrl != null) {
      final generator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
      final imageColor = generator.vibrantColor?.color ?? generator.mutedColor?.color;
      if (imageColor == null) return;
      final mutedImageColor = getIntermediateColor(imageColor, const Color.fromARGB(255, 127, 127, 127), 0.1);

      newBackgroundGradientColor = mutedImageColor;
    } else {
      newBackgroundGradientColor = _defaultBackgroundGradientColor;
    }

    if (_backgroundGradientColor != newBackgroundGradientColor) {
      setState(() {
        _backgroundGradientColor = newBackgroundGradientColor;
      });
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

  void _updateDownloadTracksCubit(GetTracksState state) {
    if (state is GetTracksTracksGettingStarted) {
      _downloadTracksCubit.setIsAllTracksGot(false);
      _downloadTracksCubit.setGettingObserver(state.observer);
    }

    if (state is GetTracksTracksGettingCountinued) {
      _downloadTracksCubit.setGettingObserver(state.observer);
      _downloadTracksCubit.continueAllTracksDownloadIfNeed();
    }

    if (state is GetTracksAfterPartGotNetworkFailure || state is GetTracksBeforePartGotNetworkFailure) {
      _downloadTracksCubit.setGettingObserver(null);
    }

    if (state is GetTracksTracksGot) {
      _downloadTracksCubit.setTracksList(state.tracksWithLoadingObservers);
    }

    if (state is GetTracksAllGot) {
      _downloadTracksCubit.setIsAllTracksGot(true);
      _downloadTracksCubit.setGettingObserver(null);
    }
  }
}
