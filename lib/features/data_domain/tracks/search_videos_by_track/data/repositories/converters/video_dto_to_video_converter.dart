import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/search_videos_by_track/domain/entities/video.dart' as entity;
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as model;

class VideoDtoToVideoConverter implements ValueConverter<entity.Video, model.Video> {
  @override
  entity.Video convert(model.Video videoDto) {
    return entity.Video(
        duration: videoDto.duration,
        url: videoDto.url,
        title: videoDto.title,
        thumbnailUrl: videoDto.thumbnails.highResUrl,
        viewsCount: videoDto.engagement.viewCount,
        author: videoDto.author);
  }

  @override
  model.Video convertBack(entity.Video value) {
    throw UnimplementedError();
  }
}
