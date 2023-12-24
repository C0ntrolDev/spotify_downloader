import 'package:spotify_downloader/core/util/converters/simple_converters/value_converter.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/album_metadata.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TrackToAudioMetadataConverter implements ValueConverter<AudioMetadata, Track> {
  @override
  AudioMetadata convert(Track track) {
    return AudioMetadata(
        name: formatStringToAudioMetadata(track.name)!,
        artists: track.artists,
        album: AlbumMetadata(
            name: formatStringToAudioMetadata(track.album?.name), 
            imageUrl: track.album?.imageUrl, 
            artists: track.parentCollection.artists));
  }

  @override
  Track convertBack(AudioMetadata value) {
    throw UnimplementedError();
  }

  String? formatStringToAudioMetadata(String? string) {
    final forbiddenChars = ['/', '\\', ':', '*', '?', '<', '>', '|'];

    String? formattedString = string;
    for (var char in forbiddenChars) {
      formattedString = formattedString?.replaceAll(char, '');
    }

    return formattedString;
  }
}
