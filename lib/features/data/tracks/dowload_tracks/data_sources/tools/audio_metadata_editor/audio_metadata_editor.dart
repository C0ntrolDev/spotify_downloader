import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';

abstract class AudioMetadataEditor {
  Future<void> changeAudioMetadata({required String audioPath, required AudioMetadata audioMetadata});
}