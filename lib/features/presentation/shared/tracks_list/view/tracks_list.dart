import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/domain/tracks/services/entities/track_with_loading_observer.dart';
import 'package:spotify_downloader/features/presentation/shared/tracks_list/widgets/track_tile/view/track_tile.dart';
import 'package:spotify_downloader/features/presentation/shared/tracks_list/widgets/track_tile_placeholder.dart';

class TracksList extends StatelessWidget {
  const TracksList({
    super.key,
    required this.collection,
    required this.itemCount,
  });

  final List<TrackWithLoadingObserver> collection;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                child: Builder(builder: (buildContext) {
                  if (index < collection.length) {
                    return TrackTile(
                      trackWithLoadingObserver: collection[index],
                      key: ObjectKey(collection[index]),
                    );
                  }

                  return const TrackTilePlaceholder();
                }),
              ),
            ],
          );
        });
  }
}