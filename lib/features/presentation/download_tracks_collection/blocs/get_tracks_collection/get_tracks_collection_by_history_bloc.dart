import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/shared/domain/ids/ids.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/base/get_tracks_collection_bloc.dart';

class GetTracksCollectionByHistoryBloc extends GetTracksCollectionBloc {
  final GetTracksCollectionById _getTracksCollection;
  final TracksCollectionId _historyTracksCollection;

  GetTracksCollectionByHistoryBloc(
      {required super.addTracksCollectionToHistory,
      required GetTracksCollectionById getTracksCollection,
      required TracksCollectionId historyTracksCollection})
      : _getTracksCollection = getTracksCollection,
        _historyTracksCollection = historyTracksCollection;

  @override
  Future<Result<Failure, TracksCollection>> loadTracksCollection() =>
      _getTracksCollection.call(TracksCollectionId(type: _historyTracksCollection.type, spotifyId: _historyTracksCollection.spotifyId));
}
