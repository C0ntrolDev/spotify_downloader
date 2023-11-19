import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_downloader/core/di/injector.dart';
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
  const DownloadTracksCollectionScreenWithHistoryTracksCollection({super.key, required HistoryTracksCollection super.historyTracksCollection});
}

class _DownloadTracksCollectionScreenState extends State<DownloadTracksCollectionScreen> {
  final DownloadTracksCollectionBloc _downloadTrackCollectionBloc = injector.get<DownloadTracksCollectionBloc>();

  _DownloadTracksCollectionScreenState() {
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
    return Container();
  }
}
