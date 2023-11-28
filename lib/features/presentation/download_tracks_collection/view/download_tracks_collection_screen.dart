import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/dowload_audio_from_youtube_args.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';
import 'dart:math' as math;

import 'package:spotify_downloader/features/presentation/shared/widgets/search_text_field.dart';

abstract class DownloadTracksCollectionScreen extends StatefulWidget {
  final String? url;
  final HistoryTracksCollection? historyTracksCollection;

  const DownloadTracksCollectionScreen({super.key, this.url, this.historyTracksCollection});

  @override
  State<DownloadTracksCollectionScreen> createState() => _DownloadTracksCollectionScreenState();
}

@RoutePage()
class DownloadTracksCollectionScreenWithUrl extends DownloadTracksCollectionScreen {
  const DownloadTracksCollectionScreenWithUrl({super.key, required String super.url});
}

@RoutePage()
class DownloadTracksCollectionScreenWithHistoryTracksCollection extends DownloadTracksCollectionScreen {
  const DownloadTracksCollectionScreenWithHistoryTracksCollection(
      {super.key, required HistoryTracksCollection super.historyTracksCollection});
}

class _DownloadTracksCollectionScreenState extends State<DownloadTracksCollectionScreen>
    with SingleTickerProviderStateMixin {
  final DownloadTracksCollectionBloc _downloadTrackCollectionBloc = injector.get<DownloadTracksCollectionBloc>();

  final ScrollController _screenScrollController = ScrollController();
  final double _tracksCollectionInfoHeight = 250;

  Color _appBarColor = const Color.fromARGB(255, 101, 101, 101);
  double _appBarOpacity = 0;

  @override
  void initState() {
    super.initState();

    if (widget.url != null) {
      _downloadTrackCollectionBloc.add(DownloadTracksCollectionLoadWithTracksCollecitonUrl(url: widget.url!));
    }

    if (widget.historyTracksCollection != null) {
      _downloadTrackCollectionBloc.add(DownloadTracksCollectionLoadWithHistoryTracksColleciton(
          historyTracksCollection: widget.historyTracksCollection!));
    }
  }

  @override
  void dispose() {
    _screenScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<DownloadTracksCollectionBloc, DownloadTracksCollectionBlocState>(
        bloc: _downloadTrackCollectionBloc,
        listener: (context, state) {
          if (state is DownloadTracksCollectionLoaded) {
            if (state.tracksCollection.bigImageUrl != null) {
              Future(() async {
                final generator =
                    await PaletteGenerator.fromImageProvider(NetworkImage(state.tracksCollection.bigImageUrl ?? ''));

                final imageColor = generator.mutedColor?.color ?? generator.dominantColor?.color;
                if (imageColor != null) {
                  _appBarColor = _getIntermediateColor(imageColor, backgroundColor, 0.2);
                }
                setState(() {});
              });
            } else {
              _appBarColor = backgroundColor;
            }
          }

          if (state is DownloadTracksCollectionFailure) {
            if (state.failure is NotFoundFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                content: Text(
                  'По данному url не было ничего найдено',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                duration: const Duration(seconds: 3),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                content: Text(
                  state.failure.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium,
                ),
                duration: const Duration(seconds: 3),
              ));
            }
            AutoRouter.of(context).pop();
          }
        },
        child: Stack(children: [
          BlocBuilder<DownloadTracksCollectionBloc, DownloadTracksCollectionBlocState>(
            bloc: _downloadTrackCollectionBloc,
            builder: (context, state) {
              if (state is DownloadTracksCollectionNetworkFailure) {
                return const Text('С соединением что-то не так');
              }

              if (state is DownloadTracksCollectionLoaded) {
                return Stack(children: [
                  Container(
                    alignment: AlignmentDirectional.topCenter,
                    child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: _screenScrollController
                          ..addListener(() {
                            _appBarOpacity = math.min(1, _screenScrollController.offset / _tracksCollectionInfoHeight);
                            setState(() {});
                          }),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                _appBarColor,
                                backgroundColor,
                              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20),
                              child: Column(children: [
                                Center(
                                    child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  imageUrl: state.tracksCollection.bigImageUrl ?? '',
                                  placeholder: (context, imageUrl) =>
                                      Image.asset('resources/images/another/loading_track_collection_image.png'),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    state.tracksCollection.name,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      SearchTextField(
                                        theme: theme,
                                        onSubmitted: (value) {},
                                        height: 35,
                                        width: 220,
                                        cornerRadius: 10,
                                        hintText: 'Поиск по названию',
                                        textStyle: theme.textTheme.bodySmall?.copyWith(color: onPrimaryColor),
                                        hintStyle: theme.textTheme.bodySmall?.copyWith(color: onSearchFieldColor),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 150,
                                        padding: const EdgeInsets.only(left: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final stream = _downloadTrackCollectionBloc.test.dowloadAudioFromYoutube(
                                                DowloadAudioFromYoutubeArgs(
                                                    youtubeUrl: 'https://youtu.be/LJfI8Z2UqhU?si=9ZzwtqtONC7KhcOt',
                                                    saveDirectoryPath: 'storage/emulated/0/Download',
                                                    audioMetadata: AudioMetadata(name: 'This Feeling 1')));
                                            stream.onEnded = (result) => print(result.failure);
                                            stream.onLoadingPercentChanged = (percent) => print(percent);
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                                          child: Text('Скачать все',
                                              style: theme.textTheme.bodySmall!.copyWith(color: onPrimaryColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              height: 10000,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]);
              }

              if (state is DownloadTracksCollectionLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container();
            },
          ),
          SizedBox(
            height: 55 + MediaQuery.of(context).viewPadding.top,
            child: Stack(
              children: [
                Opacity(
                  opacity: _appBarOpacity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [_appBarColor, _getIntermediateColor(_appBarColor, backgroundColor, 0.5)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
                  child: Row(
                    children: [
                      IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            AutoRouter.of(context).pop();
                          },
                          icon: SvgPicture.asset(
                            'resources/images/svg/back_icon.svg',
                            height: 35,
                            width: 35,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Opacity(
                          opacity: _appBarOpacity,
                          child: BlocBuilder<DownloadTracksCollectionBloc, DownloadTracksCollectionBlocState>(
                            bloc: _downloadTrackCollectionBloc,
                            buildWhen: (previous, current) => current is DownloadTracksCollectionLoaded,
                            builder: (context, state) {
                              if (state is DownloadTracksCollectionLoaded) {
                                return Center(
                                    child: Text(state.tracksCollection.name, style: theme.textTheme.titleSmall));
                              }

                              return Container();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Color _getIntermediateColor(Color color1, Color color2, double ratio) {
    return Color.fromARGB(
        (color1.alpha - (color1.alpha - backgroundColor.alpha) * ratio).round(),
        (color1.red - (color1.red - color2.red) * ratio).round(),
        (color1.green - (color1.green - color2.green) * ratio).round(),
        (color1.blue - (color1.blue - backgroundColor.blue) * ratio).round());
  }
}
