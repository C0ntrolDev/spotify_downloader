import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/features/domain/entities/track.dart';
import 'package:spotify_downloader/features/domain/history_tracks_collectons/entities/history_tracks_collection.dart';
import 'package:spotify_downloader/features/domain/shared/entities/tracks_collection.dart';

part 'download_tracks_collection_event.dart';
part 'download_tracks_collection_state.dart';

class DownloadTracksCollectionBloc extends Bloc<DownloadTracksCollectionBlocEvent, DownloadTracksCollectionBlocState> {
  DownloadTracksCollectionBloc() : super(DownloadTracksCollectionInitial()) {
  }
}
