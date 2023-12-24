import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/features/domain/tracks/observe_tracks_loading/entities/loading_tracks_collection/loading_tracks_collection_observer.dart';
import 'package:spotify_downloader/features/presentation/home/widgets/loading_tracks_collections_list/widgets/loading_tracks_collection_tile/cubit/loading_tracks_collection_tile_cubit.dart';

class LoadingTracksCollectionTile extends StatefulWidget {
  const LoadingTracksCollectionTile({super.key, this.onLoaded, required this.loadingTracksCollection});

  final void Function()? onLoaded;
  final LoadingTracksCollectionObserver loadingTracksCollection;

  @override
  State<LoadingTracksCollectionTile> createState() => _LoadingTracksCollectionTileState();
}

class _LoadingTracksCollectionTileState extends State<LoadingTracksCollectionTile> {
  late final LoadingTracksCollectionTileCubit _cubit;

  @override
  void initState() {
    _cubit = injector.get<LoadingTracksCollectionTileCubit>(param1: widget.loadingTracksCollection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadingTracksCollectionTileCubit, LoadingTracksCollectionTileState>(
      bloc: _cubit,
      listener: (context, state) {
      },
      buildWhen: (previous, current) => current is LoadingTracksCollectionTileChanged,
      builder: (context, state) {
            if (state is! LoadingTracksCollectionTileChanged) return Container();
            return Text('${state.loadingTrackInfo.tracksCollection?.name} : ${state.loadingTrackInfo.totalTracks}, ${state.loadingTrackInfo.loadedTracks}, ${state.loadingTrackInfo.failuredTracks}');
          },
        );
  }
}
