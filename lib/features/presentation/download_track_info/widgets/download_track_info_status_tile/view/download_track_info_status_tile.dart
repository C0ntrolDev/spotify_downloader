import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/widgets/download_track_info_status_tile/cubit/download_track_info_status_tile_cubit.dart';
import 'package:spotify_downloader/features/presentation/download_track_info/widgets/download_track_info_tile.dart';

class DownloadTrackInfoStatusTile extends StatefulWidget {
  const DownloadTrackInfoStatusTile({super.key, required this.trackWithLoadingObserver});

  final TrackWithLoadingObserver trackWithLoadingObserver;

  @override
  State<DownloadTrackInfoStatusTile> createState() => _DownloadTrackInfoStatusTileState();
}

class _DownloadTrackInfoStatusTileState extends State<DownloadTrackInfoStatusTile> {
  late final DownloadTrackInfoStatusTileCubit _infoStatusTileCubit;

  @override
  void initState() {
    _infoStatusTileCubit = injector.get<DownloadTrackInfoStatusTileCubit>(param1: widget.trackWithLoadingObserver);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadTrackInfoStatusTileCubit, DownloadTrackInfoStatusTileState>(
      builder: (context, state) {
        switch (state) {
          case DownloadTrackInfoStatusTileDeffault():
            return const DownloadTrackInfoTile(
                title: 'Трек не загружается', svgAssetName: 'resources/images/svg/track_tile/download_icon.svg');
          case DownloadTrackInfoStatusTileLoading():
            return DownloadTrackInfoTile(
              title: 'Трек загружается: ${state.percent ?? '...'}%',
              iconWidget: Container(
                padding: const EdgeInsets.all(0),
                height: 27,
                width: 27,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: primaryColor,
                  value: (() {
                    if (state.percent != null) {
                      return state.percent! / 100;
                    }

                    return null;
                  }).call(),
                ),
              ),
            );

          case DownloadTrackInfoStatusTileLoaded():
          case DownloadTrackInfoStatusTileFailure():
        }

        return Container();
      },
    );
  }
}
