import 'package:spotify_downloader/core/utils/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/core/utils/util_methods.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/models/metadata/album_metadata.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/models/metadata/audio_metadata.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

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
