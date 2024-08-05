import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/bloc/change_source_video_bloc.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/widgets.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage<String?>()
class ChangeSourceVideoScreen extends StatefulWidget {
  const ChangeSourceVideoScreen({super.key, required this.track, this.oldYoutubeUrl});

  final Track track;
  final String? oldYoutubeUrl;

  @override
  State<ChangeSourceVideoScreen> createState() => _ChangeSourceVideoScreenState();
}

class _ChangeSourceVideoScreenState extends State<ChangeSourceVideoScreen> {
  late final ChangeSourceVideoBloc _changeSourceVideoBloc;

  @override
  void initState() {
    _changeSourceVideoBloc = injector.get<ChangeSourceVideoBloc>(param1: widget.track);
    _changeSourceVideoBloc.add(ChangeSourceVideoLoad(selectedVideoUrl: widget.oldYoutubeUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          popPage(context);
        },
        child: SafeArea(
          left: false,
          right: false,
          child: Scaffold(
            body: Column(
              children: [
                CustomAppBar(
                  title: S.of(context).changeTheDownloadSource,
                ),
                Expanded(
                  child: BlocConsumer(
                    bloc: _changeSourceVideoBloc,
                    listener: (context, state) {
                      if (state is ChangeSourceVideoFailure) {
                        showSmallTextSnackBar(state.failure?.message.toString() ?? '', context);
                      }
                    },
                    builder: (context, state) {
                      if (state is ChangeSourceVideoLoaded) {
                        return CustomScrollView(
                          slivers: [
                            SliverList.builder(
                                itemCount: state.videos.length,
                                itemBuilder: (context, index) {
                                  final video = state.videos[index];
                                  final isVideoSelected = video == state.selectedVideo;

                                  return InkWell(
                                    splashColor: onSurfaceSplashColor,
                                    highlightColor: onSurfaceHighlightColor,
                                    onTap: () => _changeSourceVideoBloc
                                        .add(ChangeSourceVideoChangeSelectedVideo(selectedVideo: video)),
                                    child: Container(
                                        color: isVideoSelected ? onSurfaceHighlightColor : Colors.transparent,
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 10, horizontal: horizontalPadding),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              video.thumbnailUrl,
                                              height: 80,
                                              width: 100,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      video.title,
                                                      style: theme.textTheme.bodyMedium,
                                                    ),
                                                    Text(
                                                      S.of(context).nView(formatViewsCount(video.viewsCount)),
                                                      style: theme.textTheme.labelMedium
                                                          ?.copyWith(color: onBackgroundSecondaryColor),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: Text(
                                                        video.author,
                                                        style: theme.textTheme.bodyMedium
                                                            ?.copyWith(color: onBackgroundSecondaryColor),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                }),
                            const SliverToBoxAdapter(child: OrientatedNavigationBarListViewExpander())
                          ],
                        );
                      }

                      if (state is ChangeSourceVideoNetworkFailure) {
                        return NetworkFailureSplash(
                            onRetryAgainButtonClicked: () => _changeSourceVideoBloc
                                .add(ChangeSourceVideoLoad(selectedVideoUrl: widget.oldYoutubeUrl)));
                      }

                      if (state is ChangeSourceVideoLoading) {
                        return const Center(
                            child:
                                SizedBox(height: 41, width: 41, child: StrangeOptimizedCircularProgressIndicator()));
                      }

                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void popPage(BuildContext context) {
    final blocState = _changeSourceVideoBloc.state;
    if (blocState is ChangeSourceVideoLoaded && blocState.isVideoSelectedByUser) {
      Navigator.of(context).pop(blocState.selectedVideo?.url);
      return;
    }
    
    Navigator.of(context).pop(null);
  }

  String formatViewsCount(int likesCount) {
    if (likesCount < 1000) {
      return likesCount.toString();
    }

    if (likesCount < 1000000) {
      return S.of(context).nThousands(likesCount ~/ 1000);
    }

    return S.of(context).nMillions(likesCount ~/ 1000000);
  }
}
