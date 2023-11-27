import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/failures/failures.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/dowload_audio_from_youtube_data_source.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/tracks_collections/use_cases/get_tracks_collection_by_url.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  final GetTracksCollectionByUrl _getTracksCollectionByUrl;
  final DowloadAudioFromYoutubeDataSource test;

  DownloadTracksCollectionBloc({required this.test, required GetTracksCollectionByUrl getTracksCollectionByUrl})
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
