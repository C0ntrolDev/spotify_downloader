import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

part 'change_source_video_event.dart';
part 'change_source_video_state.dart';

class ChangeSourceVideoBloc extends Bloc<ChangeSourceVideoEvent, ChangeSourceVideoState> {
  final Find10VideosByTrack _find10VideosByTrack;
  final GetVideoByUrl _getVideoByUrl;
  final Track _sourceTrack;

  final List<Video> _videos = List.empty(growable: true);
  Video? _selectedVideo;

  ChangeSourceVideoBloc(
      {required Find10VideosByTrack find10VideosByTrack,
      required GetVideoByUrl getVideoByUrl,
      required Track sourceTrack,
      String? selectedVideoUrl})
      : _find10VideosByTrack = find10VideosByTrack,
        _getVideoByUrl = getVideoByUrl,
        _sourceTrack = sourceTrack,
        super(ChangeSourceVideoLoading()) {
    on<ChangeSourceVideoLoad>((event, emit) async {
      emit(ChangeSourceVideoLoading());
      final findVideosResult = await _find10VideosByTrack.call(_sourceTrack);
      if (findVideosResult.isSuccessful) {
        _videos.clear();
        _videos.addAll(findVideosResult.result ?? List.empty());

        if (event.selectedVideoUrl != null) {
          final getSelectedVideoResult = (await _getVideoByUrl.call(event.selectedVideoUrl!));
          if (getSelectedVideoResult.isSuccessful) {
            _selectedVideo = getSelectedVideoResult.result;
          } else {
            emitBasedOnFailure(getSelectedVideoResult.failure, emit);
          }
        }
        emit(ChangeSourceVideoLoaded(videos: _videos, selectedVideo: _selectedVideo, isVideoSelectedByUser: false));
      } else {
        emitBasedOnFailure(findVideosResult.failure, emit);
      }
    });

    on<ChangeSourceVideoChangeSelectedVideo>((event, emit) {
      _selectedVideo = event.selectedVideo;
      emit(ChangeSourceVideoLoaded(videos: _videos, selectedVideo: _selectedVideo, isVideoSelectedByUser: true));
    });
  }

  void emitBasedOnFailure(Failure? failure, Emitter<ChangeSourceVideoState> emit) {
    if (failure is NetworkFailure) {
      emit(ChangeSourceVideoNetworkFailure());
    } else {
      emit(ChangeSourceVideoFailure(failure: failure));
    }
  }
}
