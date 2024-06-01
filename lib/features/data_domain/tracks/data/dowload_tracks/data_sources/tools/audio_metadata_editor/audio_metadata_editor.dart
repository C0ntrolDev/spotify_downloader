import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/data/dowload_tracks/models/metadata/audio_metadata.dart';

abstract class AudioMetadataEditor {
  Future<Result<Failure, void>> changeAudioMetadata({required String audioPath, required AudioMetadata audioMetadata});
}