import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/shared/domain/entities/base_tracks_collection.dart';

class HistoryTracksCollection extends BaseTracksCollection {
  const HistoryTracksCollection({required super.id, required super.name, super.imageUrl, this.openDate});

  final DateTime? openDate;

  static HistoryTracksCollection get likedTracks => HistoryTracksCollection(id: TracksCollectionId.likedTracksId, name: 'Liked Tracks');

  @override
  List<Object?> get props => super.props + [openDate];
}
