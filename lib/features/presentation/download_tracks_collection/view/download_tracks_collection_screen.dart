import 'package:flutter/widgets.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/bloc/download_tracks_collection_bloc.dart';

class DownloadTracksCollectionScreen extends StatefulWidget {
  const DownloadTracksCollectionScreen.withTracksCollectionUrl({required String this.url, super.key})
      : historyTracksCollection = null;
  const DownloadTracksCollectionScreen.withHistoryTracksCollection(
      {required HistoryTracksCollection this.historyTracksCollection, super.key})
      : url = null;

  final String? url;
  final HistoryTracksCollection? historyTracksCollection;

  @override
  // ignore: no_logic_in_create_state
  State<DownloadTracksCollectionScreen> createState() => _DownloadTracksCollectionScreenState();
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
