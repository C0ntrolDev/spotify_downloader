import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/bloc/change_source_video_bloc.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/strange_optimized_circular_progress_indicator.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage<String?>()
class ChangeSourceVideoScreen extends StatefulWidget {
  const ChangeSourceVideoScreen({super.key, required this.track});

  final Track track;

  @override
  State<ChangeSourceVideoScreen> createState() => _ChangeSourceVideoScreenState();
}

class _ChangeSourceVideoScreenState extends State<ChangeSourceVideoScreen> {
  late final ChangeSourceVideoBloc _changeSourceVideoBloc;

  @override
  void initState() {
    _changeSourceVideoBloc = injector.get<ChangeSourceVideoBloc>(param1: widget.track);
    _changeSourceVideoBloc.add(ChangeSourceVideoLoad(selectedVideoUrl: widget.track.youtubeUrl));
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<ChangeSourceVideoBloc, ChangeSourceVideoState>(
          bloc: _changeSourceVideoBloc,
          listener: (context, state) {
            if (state is ChangeSourceVideoFailure) {
              showSmallTextSnackBar(state.failure?.message.toString() ?? '', context);
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 55 + MediaQuery.of(context).viewPadding.top,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            popPage(context);
                          },
                          icon: SvgPicture.asset(
                            'resources/images/svg/back_icon.svg',
                            height: backIconSize,
                            width: backIconSize,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            S.of(context).changeTheDownloadSource,
                            style: theme.textTheme.titleSmall,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ChangeSourceVideoBloc, ChangeSourceVideoState>(
                  bloc: _changeSourceVideoBloc,
                  builder: (context, state) {
                    if (state is ChangeSourceVideoLoaded) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
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
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          });
                    }

                    if (state is ChangeSourceVideoNetworkFailure) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).theresSomethingWrongWithConnection,
                            style: theme.textTheme.titleLarge,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(foregroundColor: primaryColor),
                              onPressed: () {},
                              child: Text(
                                S.of(context).tryAgain,
                                style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                              ))
                        ],
                      ));
                    }

                    if (state is ChangeSourceVideoLoading) {
                      return const Center(child: SizedBox(height: 41, width: 41, child: StrangeOptimizedCircularProgressIndicator()));
                    }

                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void popPage(BuildContext context) {
    if (_changeSourceVideoBloc.state is ChangeSourceVideoLoaded) {
      Navigator.of(context).pop((_changeSourceVideoBloc.state as ChangeSourceVideoLoaded).selectedVideo?.url);
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
