import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';

abstract class AudioMetadataEditor {
  Future<Result<Failure, void>> changeAudioMetadata({required String audioPath, required AudioMetadata audioMetadata});
}