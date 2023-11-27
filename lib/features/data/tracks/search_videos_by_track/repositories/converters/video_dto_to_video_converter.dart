import 'package:spotify_downloader/core/util/converters/value_converter.dart';
import 'package:spotify_downloader/features/domain/tracks/search_videos_by_track/entities/video.dart' as entity;
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as model;

class VideoDtoToVideoConverter implements ValueConverter<entity.Video, model.Video> {
  @override
  entity.Video convert(model.Video videoDto) {
    return entity.Video(
        url: videoDto.url,
        title: videoDto.title,
        thumbnailUrl: videoDto.thumbnails.highResUrl,
        likesCount: videoDto.watchPage?.videoLikeCount,
        author: videoDto.author);
  }

  @override
  model.Video convertBack(entity.Video value) {
    throw UnimplementedError();
  }
}
