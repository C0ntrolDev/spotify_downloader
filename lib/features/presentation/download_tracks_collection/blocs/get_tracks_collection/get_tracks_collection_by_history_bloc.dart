import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/history_tracks_collections/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks_collections/network_tracks_collections/domain/domain.dart';
import 'package:spotify_downloader/features/presentation/download_tracks_collection/blocs/get_tracks_collection/base/get_tracks_collection_bloc.dart';

class GetTracksCollectionByHistoryBloc extends GetTracksCollectionBloc {
  final GetTracksCollectionByTypeAndSpotifyId _getTracksCollection;
  final HistoryTracksCollection _historyTracksCollection;

  GetTracksCollectionByHistoryBloc(
      {required super.addTracksCollectionToHistory,
      required GetTracksCollectionByTypeAndSpotifyId getTracksCollection,
      required HistoryTracksCollection historyTracksCollection})
      : _getTracksCollection = getTracksCollection,
        _historyTracksCollection = historyTracksCollection;

  @override
  Future<Result<Failure, TracksCollection>> loadTracksCollection() =>
      _getTracksCollection.call((_historyTracksCollection.type, _historyTracksCollection.spotifyId));
}
