import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/entities/track.dart';
import 'package:spotify_downloader/features/domain/entities/video.dart';

abstract class YoutubeRepository {
  Result<Failure, Video> getVideoByUrl();
  Result<Failure, List<Video>> getVideosByTrack(Track track);
  Result<Failure, void> downloadAudioFromVideo(Video video);
}