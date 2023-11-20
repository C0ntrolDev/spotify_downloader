import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';

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

class _DownloadTracksCollectionScreenState extends State<DownloadTracksCollectionScreen> {
  final DownloadTracksCollectionBloc _downloadTrackCollectionBloc = injector.get<DownloadTracksCollectionBloc>();

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<DownloadTracksCollectionBloc, DownloadTracksCollectionBlocState>(
        bloc: _downloadTrackCollectionBloc,
        listenWhen: (previous, current) => current is DownloadTracksCollectionFailure,
        listener: (context, state) {
          if (state is! DownloadTracksCollectionFailure) return;

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
        },
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10),
          child: Stack(children: [
            BlocBuilder<DownloadTracksCollectionBloc, DownloadTracksCollectionBlocState>(
              bloc: _downloadTrackCollectionBloc,
              builder: (context, state) {
                if (state is DownloadTracksCollectionNetworkFailure) {
                  return const Text('С соединением что-то не так');
                }
                if (state is DownloadTracksCollectionAllLoaded) {
                  return Column(children: [
                    Image.network(state.tracksCollection.smallImageUrl ?? '', width: 300, height: 300,),
                    Text(state.tracksCollection.smallImageUrl ?? ''),
                    Text(state.tracksCollection.name),
                    Text(state.tracksCollection.spotifyId),
                  ]);
                }
                return const CircularProgressIndicator();
              },
            ),
            IconButton(
                hoverColor: Colors.red,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
                icon: SvgPicture.asset(
                  'resources/images/svg/back_icon.svg',
                  height: 35,
                  width: 35,
                ))
          ]),
        ),
      ),
    );
  }
}
