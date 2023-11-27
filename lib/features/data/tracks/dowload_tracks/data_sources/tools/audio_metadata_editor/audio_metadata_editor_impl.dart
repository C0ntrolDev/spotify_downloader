import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/data_sources/tools/audio_metadata_editor/audio_metadata_editor.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';

class AudioMetadataEditorImpl implements AudioMetadataEditor {
  @override
  Future<void> changeAudioMetadata({required String audioPath, required AudioMetadata audioMetadata}) async {
     return await MetadataGod.writeMetadata(file: audioPath, metadata: Metadata(
        title: audioMetadata.name,
        artist: audioMetadata.artists?.join(', '),
        durationMs: audioMetadata.durationMs,
        album: audioMetadata.album?.name,
        albumArtist: audioMetadata.album?.artists?.join(', '),
        trackTotal: audioMetadata.album?.totalTracksCount,
        trackNumber: audioMetadata.trackNumber,
        year: audioMetadata.realiseYear
      ));
  }
}