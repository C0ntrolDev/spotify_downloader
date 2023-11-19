import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/tracks_collection.dart';
import 'package:spotify_downloader/features/domain/spotify_api/enitites/track.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  DownloadTracksCollectionBloc() : super(DownloadTracksCollectionInitial()) {
    on((event, emit) => null);
  }
}
