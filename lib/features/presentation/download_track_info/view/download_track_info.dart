import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/bloc/download_track_info_bloc.dart';

void showDownloadTrackInfoBottomSheet(BuildContext context, TrackWithLoadingObserver trackWithLoadingObserver) {
  showModalBottomSheet(
      context: context,
      builder: (buildContext) {
        return DownloadTrackInfo(
          trackWithLoadingObserver: trackWithLoadingObserver,
        );
      });
}

class DownloadTrackInfo extends StatefulWidget {
  const DownloadTrackInfo({super.key, required this.trackWithLoadingObserver});

  final TrackWithLoadingObserver trackWithLoadingObserver;

  @override
  State<DownloadTrackInfo> createState() => _DownloadTrackInfoState();
}

class _DownloadTrackInfoState extends State<DownloadTrackInfo> {
  late final DownloadTrackInfoBloc _downloadTrackInfoBloc;

  @override
  void initState() {
    super.initState();
    _downloadTrackInfoBloc = injector.get<DownloadTrackInfoBloc>(param1: widget.trackWithLoadingObserver);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300
    );
  }
}
