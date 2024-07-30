import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/entities/track.dart';

class TrackWithLazyYoutubeUrl {
  TrackWithLazyYoutubeUrl({required this.track, required this.getYoutubeUrl});

  final Track track;
  final Future<Result<Failure, String>> Function() getYoutubeUrl;
}
