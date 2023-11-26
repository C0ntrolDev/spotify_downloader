import 'package:spotify_downloader/core/util/converters/value_converter.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/models/metadata/album_metadata.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/models/metadata/audio_metadata.dart';
import 'package:spotify_downloader/features/domain/shared/entities/track.dart';

class TrackToAudioMetadataConverter implements ValueConverter<AudioMetadata, Track> {
  @override
  AudioMetadata convert(Track track) {
    return AudioMetadata(
        name: track.name,
        artists: track.artists,
        realiseYear: track.realiseYear,
        imageUrl: track.imageUrl,
        trackNumber: track.trackNumber,
        album: AlbumMetadata(
            name: track.parentCollection.name,
            artists: track.parentCollection.artists,
            totalTracksCount: track.parentCollection.tracksCount));
  }

  @override
  Track convertBack(AudioMetadata value) {
    throw UnimplementedError();
  }
}
