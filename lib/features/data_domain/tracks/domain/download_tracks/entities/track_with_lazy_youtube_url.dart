import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

class TrackWithLazyYoutubeUrl {
  TrackWithLazyYoutubeUrl({required this.track, required this.getYoutubeUrlFunction});

  final Track track;
  final Future<Result<Failure, String>> Function() getYoutubeUrlFunction;

  Future<Result<Failure, String>> getYoutubeUrl() async {
    if (track.youtubeUrl != null) {
      return Result.isSuccessful(track.youtubeUrl!);
    } else {
      final youtubeUrlResult = await getYoutubeUrlFunction.call();
      if (youtubeUrlResult.isSuccessful) {
        track.youtubeUrl = youtubeUrlResult.result;
      }
      return youtubeUrlResult;
    }
  }
}
