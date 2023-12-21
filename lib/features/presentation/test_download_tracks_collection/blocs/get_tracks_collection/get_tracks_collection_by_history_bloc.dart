import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/network_tracks_collections/use_cases/get_tracks_collection_by_history_tracks_collection.dart';
import 'package:spotify_downloader/features/presentation/test_download_tracks_collection/blocs/get_tracks_collection/base/get_tracks_collection_bloc.dart';

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
