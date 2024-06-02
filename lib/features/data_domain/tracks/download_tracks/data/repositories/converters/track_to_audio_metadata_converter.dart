import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

class TrackToAudioMetadataConverter implements ValueConverter<AudioMetadata, Track> {
  @override
  AudioMetadata convert(Track track) {
    return AudioMetadata(
        name: formatStringToFileFormat(track.name)!,
        artists: track.artists,
        album: AlbumMetadata(
            name: formatStringToFileFormat(track.album?.name), 
            imageUrl: track.album?.imageUrl, 
            artists: track.parentCollection.artists));
  }

  @override
  Track convertBack(AudioMetadata value) {
    throw UnimplementedError();
  }
}
