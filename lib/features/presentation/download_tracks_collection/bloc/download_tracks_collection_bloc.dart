import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/track.dart';
import 'package:spotify_downloader/features/domain/spotify_api/use_cases/get_tracks_collection_by_url.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  final GetTracksCollectionByUrl _getTracksCollectionByUrl;

  DownloadTracksCollectionBloc({required GetTracksCollectionByUrl getTracksCollectionByUrl})
      : _getTracksCollectionByUrl = getTracksCollectionByUrl,
        super(DownloadTracksCollectionLoading()) {
    on<DownloadTracksCollectionLoadWithTracksCollecitonUrl>((event, emit) async {
      final result = await _getTracksCollectionByUrl.call(event.url);
      if (result.isSuccessful) {
        emit(DownloadTracksCollectionAllLoaded(List.empty(), tracksCollection: result.result!));
      }
      else {
        if (result.failure is NetworkFailure) {
          emit(DownloadTracksCollectionNetworkFailure());
        }
        else {
          emit(DownloadTracksCollectionFailure(failure: result.failure!));
        }
        
      }
    });
  }
}
