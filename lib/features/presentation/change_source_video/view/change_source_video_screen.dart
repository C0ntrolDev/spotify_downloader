import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/themes/themes.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/presentation/change_source_video/bloc/change_source_video_bloc.dart';

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

    return Scaffold(
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
                          AutoRouter.of(context).pop();
                        },
                        icon: SvgPicture.asset(
                          'resources/images/svg/back_icon.svg',
                          height: 35,
                          width: 35,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Изменить источник загрузки',
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ListView.builder(
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 1,
                            );
                          }),
                    );
                  }

                  if (state is ChangeSourceVideoNetworkFailure) {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'С соединением что-то не так',
                          style: theme.textTheme.titleLarge,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(foregroundColor: primaryColor),
                            onPressed: () {},
                            child: Text(
                              'Попробовать снова',
                              style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                            ))
                      ],
                    ));
                  }

                  if (state is ChangeSourceVideoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
